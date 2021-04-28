//
//  EditProfileViewController.swift
//  MinisasNovelties
//
//  Created by Paola Rodriguez on 4/2/21.
//  Copyright @ 2021 Paola Rodriguez. All rights reserved.
//

import UIKit
import JGProgressHUD

class EditProfileViewController: UIViewController {

//MARK: - IBOutlets * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var surNameTextField: UITextField!
    
    @IBOutlet weak var addressTextField: UITextField!
    
//MARK: - Variables * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    let hud = JGProgressHUD(style: .light)
    
   
//MARK: - View Lifecycle * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadUserInfo()
        
    }
    
//MARK: - IBActions * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    @IBAction func saveBarButtonPressed(_ sender: Any) {
        
        dismmissKeyboard()
        
        if textFieldsHaveText() {
            
            let withValues = [kFIRSTNAME: nameTextField.text!, kLASTNAME: surNameTextField.text!, kFULLNAME: (nameTextField.text! + " " + surNameTextField.text!), kFULLADDRESS: addressTextField.text!]
            
            updateCurrentUserInFirestore(withValues: withValues) { (error) in
                
                if error == nil {
                    
                    self.hud.textLabel.text = "Updated"
                    self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                    self.hud.show(in: self.view)
                    self.hud.dismiss(afterDelay: 2.0)
                    
                } else {
                    
                    print("Error updating user", error!.localizedDescription)
                    self.hud.textLabel.text = error!.localizedDescription
                    self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                    self.hud.show(in: self.view)
                    self.hud.dismiss(afterDelay: 2.0)
                    
                }
                
            }
            
        } else {
            
            hud.textLabel.text = "All fields are required."
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 2.0)
            
        }
        
    }
    
    @IBAction func logOutButtonPressed(_ sender: Any) {
        
        logOutUser()
        
    }
    
//MARK: Update User Interface * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    private func loadUserInfo() {
        
        if MUser.currentUser() != nil {
            
            let currentUser = MUser.currentUser()!
            
            nameTextField.text = currentUser.firstName
            
            surNameTextField.text = currentUser.lastName
            
            addressTextField.text = currentUser.fullAddress
            
            print(currentUser.isAdmin)
            
        }
    }

//MARK: - Helper Functions * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    private func dismmissKeyboard() {
        
        self.view.endEditing(false)
        
    }
    
    private func textFieldsHaveText() -> Bool {
        
        return nameTextField.text != "" && surNameTextField.text != "" && addressTextField.text != ""
        
    }
    
    private func logOutUser() {
        
        MUser.logOutCurrentUser { (error) in
            
            if error == nil {
                
            print("Logged out")
            self.navigationController?.popViewController(animated: true)
                
            } else {
                
                print("Error Loging Out", error!.localizedDescription)
                
            }
            
        }
        
    }
    
}
