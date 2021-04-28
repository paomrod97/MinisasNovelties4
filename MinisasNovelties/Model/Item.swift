//
//  Item.swift
//  MinisasNovelties
//
//  Created by Paola Rodriguez on 3/17/21.
//  Copyright @ 2021 Paola Rodriguez. All rights reserved.
//

import Foundation
import UIKit
import InstantSearchClient

class Item {
    
//MARK: - Variables * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    var id: String!
    var categoryId: String!
    var name: String!
    var description: String!
    var price: Double!
    var imageLinks: [String]!
    var quantity: String!
    var clientQuantity2: Int!

    
//MARK: - Initializers * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

    init() {
        
    }
    
    init(_dictionary: NSDictionary) {
        
        id = _dictionary[kOBJECTID] as? String
        categoryId = _dictionary[kCATEGORYID] as? String
        name = _dictionary[kNAME] as? String
        description = _dictionary[kDESCRIPTION] as? String
        price = _dictionary[kPRICE] as? Double
        imageLinks = _dictionary[kIMAGELINKS] as? [String]
        quantity = _dictionary[kQUANTITY] as? String
        clientQuantity2 = _dictionary[kCLIENTQUANTITY2] as? Int
        
    }

}

//MARK: - Save Items Func * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

func saveItemToFirestore (_ item: Item) {
    FirebaseReference(.Items).document(item.id).setData(itemDictionaryFrom(item) as! [String: Any])
}

//MARK: - Helper Functions * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

func itemDictionaryFrom(_ item: Item) -> NSDictionary {
   
    return NSDictionary(objects: [item.id, item.categoryId, item.name, item.description, item.price, item.imageLinks, item.quantity, item.clientQuantity2], forKeys: [kOBJECTID as NSCopying, kCATEGORYID as NSCopying, kNAME as NSCopying, kDESCRIPTION as NSCopying, kPRICE as NSCopying, kIMAGELINKS as NSCopying, kQUANTITY as NSCopying, kCLIENTQUANTITY2 as NSCopying])
    
}

//MARK: Download Func * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

func downloadItemsFromFirebase(_ withCategoryId: String, completion: @escaping (_ itemArray: [Item]) -> Void) {
    
    var itemArray: [Item] = []
    
    FirebaseReference(.Items).whereField(kCATEGORYID, isEqualTo: withCategoryId).getDocuments { (snapshot, error) in
        
        guard let snapshot = snapshot else {
            completion(itemArray)
            return
        }
        
        if !snapshot.isEmpty {
            
            for itemDict in snapshot.documents {
                
                itemArray.append(Item(_dictionary: itemDict.data() as NSDictionary))
            }
        }
        
        completion(itemArray)
    }
    
}

//MARK: DOWNLOAD ALL ITEMS * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

func downloadAllItemsFromFirebase(completion: @escaping (_ itemArray: [Item]) -> Void) {
    
    var itemArray: [Item] = []
    
    FirebaseReference(.Items).getDocuments { (snapshot, error) in
        
        guard let snapshot = snapshot else {
            completion(itemArray)
            return
        }
        
        if !snapshot.isEmpty {
            
            for itemDict in snapshot.documents {
                
                itemArray.append(Item(_dictionary: itemDict.data() as NSDictionary))
            }
        }
        
        completion(itemArray)
    }
    
}

//MARK: - Download Func Basket * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

func downloadItems(_ withIds: [String], completion: @escaping (_ itemArray: [Item]) -> Void) {
    
    var count = 0
        var itemArray: [Item] = []
        
        if withIds.count > 0 {
            
            for itemId in withIds {
                
                FirebaseReference(.Items).document(itemId).getDocument { (snapshot, error) in
                    
                    guard let snapshot = snapshot else {
                        completion(itemArray)
                        return
                    }
                    
                    if snapshot.exists {
                        
                        itemArray.append(Item(_dictionary: snapshot.data()! as NSDictionary))
                        count += 1
                        
                    } else {
                        completion(itemArray)
                    }
                    
                    if count == withIds.count {
                        completion(itemArray)
                    }
                    
                }
            }
        } else {
            completion(itemArray)
        }
        
        
    }

//MARK: - Algolia Funcs * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

func saveItemToAlgolia(item: Item) {
    
    let index = AlgoliaService.shared.index
        
    let itemToSave = itemDictionaryFrom(item) as! [String: Any]
    
    index.addObject(itemToSave, withID: item.id, requestOptions: nil) { (content, error) in
        
        if error != nil {
            
            print("Error saving to Algolia", error!.localizedDescription)
            
        } else {
            
            print("Added to Algolia")
            
        }
    }
}

func searchAlgolia(searchString: String, completion: @escaping (_ itemArray: [String]) -> Void) {
    
    let index = AlgoliaService.shared.index
    
    var resultIds: [String] = []
    
    let query = Query(query: searchString)
    
    query.attributesToRetrieve = ["name", "description", "quantity"]
    
    index.search(query) { (content, error) in
        
        if error == nil {
            
            let cont = content!["hits"] as! [[String: Any]]
            
            resultIds = []
            
            for result in cont {
                
                resultIds.append(result["objectID"] as! String)
                
            }
            
            completion(resultIds)
            
        } else {
            
            print("Error Algolia Search", error!.localizedDescription)
            completion(resultIds)
            
        }
    }
}

//MARK: - Update items * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

//func currentItem() -> Item? {
//
//    if Item.self != nil {
//
//        //if let dictionary = Item.standard.object(forKey: kITEMIDS) {
//            
//            return Item.init(_dictionary: dictionary as! NSDictionary)
//        //}
//    }
//    
//    return nil
    

//class func currentUser() -> MUser? {
//
//    if Auth.auth().currentUser != nil {
//
//        if let dictionary = UserDefaults.standard.object(forKey: kCURRENTUSER) {
//
//            return MUser.init(_dictionary: dictionary as! NSDictionary)
//        }
//    }
    
//    return nil

//func updateCurrentItemInFirestore(_ item: Item, withValues: [String : Any], completion: @escaping (_ error: Error?) -> Void) {
//
//    FirebaseReference(.Items).document(item.id).updateData(withValues) { (error) in
//        completion(error)
//    }
//
//}

//func updateCurrentItemInFirestore(_ item: Item, withValues: [String : Any], completion: @escaping (_ error: Error?) -> Void) {
//
//    FirebaseReference(.Items).document(item.id).updateData(withValues) { (error) in
//        completion(error)
//    }
//
//}

//func updateCurrentItemInFirestore(_ item: Item, withValues: [String : Any], completion: @escaping (_ error: Error?) -> Void) {
//
//    FirebaseReference(.Items).document(item.id).updateData(withValues) { (error) in
//        completion(error)
//    }
//
//}

//func updateCurrentItemInFirestore(withValues: [String: Any], completion: @escaping(_ error: Error?) -> Void) {
//
//    if let dictionary = UserDefaults.standard.object(forKey: kCURRENTUSER) {
//
//        let userObject = (dictionary as! NSDictionary).mutableCopy() as! NSMutableDictionary
//
//        userObject.setValuesForKeys(withValues)
//
//        FirebaseReference(.User).document(MUser.currentId()).updateData(withValues) { (error) in
//
//            completion(error)
//
//            if error == nil {
//
//                saveUserLocally(mUserDictionary: userObject)
//
//            }
//        }
        
 //   }

//MARK: - Delete items * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
//
//func deleteItemInFirestore(_ item: Item, withValues: [String : Any], completion: @escaping (_ error: Error?) -> Void) {
//
//        FirebaseReference(.Items).document(item.id).delete() { (error) in
//            completion(error)
//        }
//    }

func deleteItemInFirestore(_ itemId: String, completion: @escaping (_ itemArray: [Item]) -> Void) {
    
    var itemArray: [Item] = []
    
    print ("before function")
    print(itemId)
    print("delete")
    
    FirebaseReference(.Items).document(itemId).delete() { err in
        if let err = err {
            print("Error removing document: \(err)")
        } else {
            print("Document successfully removed!")
        }
    }
    
    print("after function")
    print(itemId)
}

func updateCurrentItemInFirestore(_ itemId: String,  withValues: [String : Any], completion: @escaping (_ itemArray: [Item]) -> Void) {

    var itemArray: [Item] = []

    print ("before function")
    print(itemId)
    print("edit")
    
    FirebaseReference(.Items).document(itemId).updateData(withValues) { (err) in
        
        if let err = err {
            print("Error reditingdocument: \(err)")
        } else {
            print("Document successfully removed!")
        }
    }
    
    
    print("after function")
    print(itemId)

}
