//
//  FinishRegistrationViewController.swift
//  MinisasNovelties
//
//  Created by Paola Rodriguez on 4/1/21.
//  Copyright @ 2021 Paola Rodriguez. All rights reserved.
//

import UIKit
import JGProgressHUD

class FinishRegistrationViewController: UIViewController {

//MARK: - IBOutlets * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var surNameTextField: UITextField!
    
    @IBOutlet weak var addressTextField: UITextField!
    
    @IBOutlet weak var doneButtonOutlet: UIButton!
    
//MARK: - Variables * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    let hud = JGProgressHUD(style: .light)
    
//MARK: - View Lifecycle * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        surNameTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)

        addressTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)

    }

//MARK: - IBActions * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        
        finishOnBoarding()
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        print("Text Field Did Change")
        updateDoneButtonStatus()
        
    }
    
//MARK: Helper * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    private func updateDoneButtonStatus() {
        
        if nameTextField.text != "" && surNameTextField.text != "" && addressTextField.text != "" {
            
            doneButtonOutlet.backgroundColor = #colorLiteral(red: 0.7803921569, green: 0.1882352941, blue: 0.4509803922, alpha: 1)
            doneButtonOutlet.isEnabled = true
            
        } else {
            
            doneButtonOutlet.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            doneButtonOutlet.isEnabled = false
            
        }
        
    }
    
    private func finishOnBoarding() {
        
        let withValues = [kFIRSTNAME: nameTextField.text!, kLASTNAME: surNameTextField.text!, kONBOARD: true, kISADMIN: false, kFULLADDRESS: addressTextField.text!, kFULLNAME: (nameTextField.text! + " " + surNameTextField.text!)] as [String: Any]
        
        updateCurrentUserInFirestore(withValues: withValues) { (error) in
            
            if error == nil {
                
                self.hud.textLabel.text = "Updated!"
                self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
                
                self.dismiss(animated: true, completion: nil)
                
            } else {
                
                print("Error updating user \(error!.localizedDescription)")
                 
                self.hud.textLabel.text = error!.localizedDescription
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
                
            }
        }
        
    }
    
}
