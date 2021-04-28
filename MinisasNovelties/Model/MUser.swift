//
//  MUser.swift
//  MinisasNovelties
//
//  Created by Paola Rodriguez on 3/31/21.
//  Copyright @ 2021 Paola Rodriguez. All rights reserved.
//

import Foundation
import FirebaseAuth

class MUser {
    
//MARK: - Variables * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    let objectId: String
    var email: String
    var firstName: String
    var lastName: String
    var fullName: String
    var purchasedItemsIds: [String]
    
    var fullAddress: String?
    var onBoard: Bool
    var isAdmin: Bool
    
//MARK: - Initializers * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    init(_objectId: String, _email: String, _firstName: String, _lastName: String) {
        
        objectId = _objectId
        email = _email
        firstName = _firstName
        lastName = _lastName
        fullName = _firstName + "" + _lastName
        onBoard = false
        isAdmin = false
        purchasedItemsIds = []
        
    }
    
    init(_dictionary: NSDictionary) {
        
        objectId = _dictionary[kOBJECTID] as! String
        
        if let mail = _dictionary[kEMAIL] {
            
            email = mail as! String
            
        } else {
                email = ""
        }
        
        if let fname = _dictionary[kFIRSTNAME] {
            
            firstName = fname as! String
            
        } else {
            
            firstName = ""
        }
        
        if let lname = _dictionary[kLASTNAME] {
            
            lastName = lname as! String
            
        } else {
            
            lastName = ""
        }
        
        fullName = firstName + " " + lastName
        
        if let faddress = _dictionary[kFULLADDRESS] {
            
            fullAddress = faddress as! String
            
        } else {
            
            fullAddress = ""
        }
        
        if let onB = _dictionary[kONBOARD] {
            
            onBoard = onB as! Bool
        
        } else {
    
            onBoard = false
    
        }
    
        if let isA = _dictionary[kISADMIN] {
                
            isAdmin = isA as! Bool
                
        } else {
            
        
            isAdmin = false
        }
        
        if let purchasedIds = _dictionary[kPURCHASEDITEMSIDS] {
            
            purchasedItemsIds  = purchasedIds as! [String]
            
        } else {
            
            purchasedItemsIds  = []
        }
    }
    
//MARK: - Return Current User * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    class func currentId() -> String {
        
        return Auth.auth().currentUser!.uid
        
    }
    
    class func currentUser() -> MUser? {

        if Auth.auth().currentUser != nil {

            if let dictionary = UserDefaults.standard.object(forKey: kCURRENTUSER) {
                
                return MUser.init(_dictionary: dictionary as! NSDictionary)
            }
        }
        
        return nil
        
    }
    
//MARK: - Log In Func * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

    class func logInUserWith(email: String, password: String, completion: @escaping(_ error: Error?, _ isEmailVerified: Bool) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            
            if error == nil {
                
                if authDataResult!.user.isEmailVerified {
                    
                    print(Auth.auth().currentUser)
                    downloadUserFromFirestore(userId: authDataResult!.user.uid, email: email)
                    completion(error, true)
                    
                } else {
                    
                    print("Email is not verified.")
                    completion(error, false)
                    
                }
                
            } else {
                
                completion(error, false)
                
            }
        }
        
    }
    
//MARK: Register User * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    class func registerUserWith(email: String, password: String, completion: @escaping(_ error: Error?) -> Void) {
    
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
            
            completion(error)
            
            if error == nil {
                                
                authDataResult!.user.sendEmailVerification { (error) in
                    
                    print("auth email verification error:  ", error?.localizedDescription)
                }
            }
        }
    }

//MARK: Resend Link Methods * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

class func resetPasswordFor(email: String, completion: @escaping (_ error: Error?) -> Void) {
            
    Auth.auth().sendPasswordReset(withEmail: email) { (error) in
        
        completion(error)
    }
            
    }
    
    class func resendVerificationEmail(email: String, completion: @escaping(_ error: Error?) -> Void) {
        
        Auth.auth().currentUser?.reload(completion: { (error) in
            
            Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                print("Rsesend email error: ", error?.localizedDescription)
                
                completion(error)
            })
        })
    }
    
    class func logOutCurrentUser(completion: @escaping (_ error: Error?) -> Void) {
        
        do {
            
            try Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: kCURRENTUSER)
            UserDefaults.standard.synchronize()
            completion(nil)

        } catch let error as NSError {
            completion(error)

        }
    }
    
}

//MARK: - Download User * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

func downloadUserFromFirestore(userId: String, email: String) {
    
    FirebaseReference(.User).document(userId).getDocument() { (snapshot, error) in
        
        guard let snapshot = snapshot else {return}
        
        if snapshot.exists {
            
            print("Download current user from Firestore.")
            saveUserLocally(mUserDictionary: snapshot.data()! as NSDictionary)
            
        } else {
            
            //there is no user, save new user in Firestore
            
            let user = MUser(_objectId: userId, _email: email, _firstName: "", _lastName: "")
            saveUserLocally(mUserDictionary: userDictionaryFrom(user: user))
            saveUserToFirestore(mUser: user)
        }
    }
    
}

//MARK: Save User To Firebase * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

func saveUserToFirestore(mUser: MUser) {
    
    FirebaseReference(.User).document(mUser.objectId).setData(userDictionaryFrom(user: mUser) as! [String: Any]) { (error) in
    
        if error != nil {
            
            print("Error saving user. \(error!.localizedDescription)")
            
        }
        
    }
    
}

func saveUserLocally(mUserDictionary: NSDictionary) {
    
    UserDefaults.standard.set(mUserDictionary, forKey: kCURRENTUSER)
    UserDefaults.standard.synchronize()
    
}

//MARK: Helper Function * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

func userDictionaryFrom(user: MUser) -> NSDictionary {
    
    return NSDictionary(objects: [user.objectId, user.email, user.firstName, user.lastName, user.fullName, user.fullAddress ?? "", user.onBoard, user.isAdmin, user.purchasedItemsIds], forKeys: [kOBJECTID as NSCopying, kEMAIL as NSCopying, kFIRSTNAME as NSCopying, kLASTNAME as NSCopying, kFULLNAME as NSCopying, kFULLADDRESS as NSCopying, kONBOARD as NSCopying, kISADMIN as NSCopying, kPURCHASEDITEMSIDS as NSCopying])
    
}

//MARK: Update User * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

func updateCurrentUserInFirestore(withValues: [String: Any], completion: @escaping(_ error: Error?) -> Void) {
    
    if let dictionary = UserDefaults.standard.object(forKey: kCURRENTUSER) {
        
        let userObject = (dictionary as! NSDictionary).mutableCopy() as! NSMutableDictionary
        
        userObject.setValuesForKeys(withValues)
        
        FirebaseReference(.User).document(MUser.currentId()).updateData(withValues) { (error) in
            
            completion(error)
            
            if error == nil {
                
                saveUserLocally(mUserDictionary: userObject)
                
            }
        }
        
    }
    
}
