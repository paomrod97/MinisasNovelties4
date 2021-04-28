//
//  WelcomeViewController.swift
//  MinisasNovelties
//
//  Created by Paola Rodriguez on 3/29/21.
//  Copyright @ 2021 Paola Rodriguez. All rights reserved.
//

import UIKit
import JGProgressHUD
import NVActivityIndicatorView
import Firebase
import FirebaseAuth
import FirebaseFirestore

class WelcomeViewController: UIViewController {
    
//MARK: - IBOutlets * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var resendButtonOutlet: UIButton!

//MARK: - Variables * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
        
    let hud = JGProgressHUD(style: .light)
    var activityIndicator: NVActivityIndicatorView?
    
//MARK: - View Lifecycle * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        loadUserInfo()

       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60, height: 60), type: .ballPulse, color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), padding: nil)
    }
    
//MARK: - IBActions * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

    @IBAction func cancelButtonPressed(_ sender: Any) {
        
        dismissView()
        
    }
    
    @IBAction func logInButtonPressed(_ sender: Any) {
        
        print("login")
        
        if textFieldsHaveText() {
            
        logInUser()
            
            
        } else {
            hud.textLabel.text = "All fields are required."
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 2.0)
        }
        
        
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        
        print("register")
        
        if textFieldsHaveText() {
            
            registerUser()
            
        } else {
            hud.textLabel.text = "All fields are required."
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 2.0)
        }
    }
    
    @IBAction func forgotPasswordButtonPressed(_ sender: Any) {
        
        print("forgot password")
        
        if emailTextField.text != "" {
            
            resetPassword()
            
        } else {
            
            hud.textLabel.text = "Please insert email."
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 2.0)
            
        }
        
    }
    
    @IBAction func resendEmailButtonPressed(_ sender: Any) {
    
        print("resend email")
        
        MUser.resendVerificationEmail(email: emailTextField.text!) { (error) in
            
            print("Error resend link email", error?.localizedDescription)
        }
    
    }
    
//MARK: - Log In User * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
//    private func logInUser() {
//
//        showLoadingIndicator()
//
//        MUser.logInUserWith(email: emailTextField.text!, password: passwordTextField.text!) { (error, isEmailVerified) in
//
//            if error == nil {
//
//                if isEmailVerified {
//
//                    self.dismissView()
//                    print("Email is verified")
//
//                } else {
//
//                    self.hud.textLabel.text = "Please verify your email."
//                    self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
//                    self.hud.show(in: self.view)
//                    self.hud.dismiss(afterDelay: 2.0)
//                    self.resendButtonOutlet.isHidden = false
//
//                }
//
//            } else {
//
//                print("Error loging in the user.", error!.localizedDescription)
//                self.hud.textLabel.text = error!.localizedDescription
//                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
//                self.hud.show(in: self.view)
//                self.hud.dismiss(afterDelay: 2.0)
//
//            }
//
//            self.hideLoadingIndicator()
//        }
//
//    }
    
    
    
        private func logInUser() {
    
            showLoadingIndicator()
    
            MUser.logInUserWith(email: emailTextField.text!, password: passwordTextField.text!) { (error, isEmailVerified) in
    
                if error == nil {
    
                    if isEmailVerified {
    
                        self.dismissView()
                        print("Email is verified")
                        
                       // self.userRoleListener()
                        
                        
                        
                        
                        
                        
    
                    } else {
    
                        self.hud.textLabel.text = "Please verify your email."
                        self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                        self.hud.show(in: self.view)
                        self.hud.dismiss(afterDelay: 2.0)
                        self.resendButtonOutlet.isHidden = false
    
                    }
    
                } else {
    
                    print("Error loging in the user.", error!.localizedDescription)
                    self.hud.textLabel.text = error!.localizedDescription
                    self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                    self.hud.show(in: self.view)
                    self.hud.dismiss(afterDelay: 2.0)
    
                }
    
                self.hideLoadingIndicator()
            }
    
        }
        
    
    
//    private func logInUser() {
//
//        showLoadingIndicator()
//
//        guard let User = Auth.auth().currentUser?.uid else { return }
//
//        Firestore.firestore().collection("MUser").document(User).getDocument { (snapshot, error) in
//
//        if let data = snapshot?.data() {
//
//        guard let isAdmin = data["isAdmin"] as? Bool else { return }
//
//            if isAdmin {
//
//                print("Es administrador.")
//
////                let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "adminVC") as! AdminViewController
////
////                //vc.delegate = self
////                self.present(vc, animated: true, completion: nil)
//
//           } else {
//
//            print("No es administrador.")
//
////            MUser.logInUserWith(email: self.emailTextField.text!, password: self.passwordTextField.text!) { (error, isEmailVerified) in
////
////                          if error == nil {
////
////                              if isEmailVerified {
////
////                                  self.dismissView()
////                                  print("Email is verified")
////
////                              } else {
////
////                                  self.hud.textLabel.text = "Please verify your email."
////                                  self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
////                                  self.hud.show(in: self.view)
////                                  self.hud.dismiss(afterDelay: 2.0)
////                                  self.resendButtonOutlet.isHidden = false
////
////                              }
////
////                          } else {
////
////                              print("Error loging in the user.", error!.localizedDescription)
////                              self.hud.textLabel.text = error!.localizedDescription
////                              self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
////                              self.hud.show(in: self.view)
////                              self.hud.dismiss(afterDelay: 2.0)
////
////                          }
////
////                          self.hideLoadingIndicator()
////                      }
//
//                  }
//
//            //let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "categoryVC") as! CategoryCollectionViewController
//           }
//          }
//         }
//
//
  
          
    
//MARK: - Register User * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    private func registerUser() {
        
        showLoadingIndicator()
        
        MUser.registerUserWith(email: emailTextField.text!, password: passwordTextField.text!) { (error) in
            
            
            
            
            if error == nil {
        
                
               //if Validators.isEmailValid(self.emailTextField.text!) == true {
                    
                self.hud.textLabel.text = "Verification email sent."
                self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
                    
                //} else {
                    
                    //print("Please enter a valid email address")
                    
            //} else {
                
                
            //if Validators.isPasswordValid(self.passwordTextField.text!) == true {
                    
//                self.hud.textLabel.text = "Password Acepted."
//                self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
//                self.hud.show(in: self.view)
//                self.hud.dismiss(afterDelay: 2.0)
//            
            //} else {
                
                //print("Please make sure your password is at least 8 characters long, contains a special character and a number")
                
                //}
                
                
                
            } else {
                
                print("Error Registering", error!.localizedDescription)
                self.hud.textLabel.text = error!.localizedDescription
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
                
            }
            
            self.hideLoadingIndicator()
        }
        
    }
    
//MARK: - Helpers * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    private func resetPassword() {
          
        MUser.resetPasswordFor(email: emailTextField.text!) { (error) in
            
            if error == nil {
                
                self.hud.textLabel.text = "Reset password email sent."
                self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
                
            } else {
                
                self.hud.textLabel.text = error!.localizedDescription
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
                
            }
      }
    }
    
    private func textFieldsHaveText() -> Bool {
        
        return (emailTextField.text != "" && passwordTextField.text != "" )
    }
    
    
    private func dismissView() {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
//MARK: - Activity Indicator * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    private func showLoadingIndicator() {
        
        if activityIndicator != nil {
            
            self.view.addSubview(activityIndicator!)
            activityIndicator?.startAnimating()
        }
        
    }
    
    private func hideLoadingIndicator() {
        
        if activityIndicator != nil {
            
            activityIndicator!.removeFromSuperview()
            activityIndicator?.stopAnimating()
        }
    }
    
//    private func loadUserInfo() {
//
//        if MUser.currentUser() != nil {
//
//            let currentUser = MUser.currentUser()!
//
//            if currentUser.isAdmin == true {
//
//
//
//            } else {
//
//            }
//
//            print(currentUser.isAdmin)
//
//        }
//    }
}




