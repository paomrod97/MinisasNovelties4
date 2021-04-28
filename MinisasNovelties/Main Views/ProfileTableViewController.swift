//
//  ProfileTableViewController.swift
//  MinisasNovelties
//
//  Created by Paola Rodriguez on 4/1/21.
//  Copyright @ 2021 Paola Rodriguez. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {

//MARK: - IBOulets * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    @IBOutlet weak var finishRegistrationButtonOutlet: UIButton!
    
    @IBOutlet weak var purchaseHistoryButtonOutlet: UIButton!
    
    @IBOutlet weak var administratorDashboard: UIButton!
    
    @IBOutlet weak var administrativeDashboardCell: UIView!
    
    //MARK: - Variables * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    var editBarButtonOutlet: UIBarButtonItem!
    
//MARK: - View Lifecycle * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadAdminUserInfo()

        tableView.tableFooterView = UIView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkLogInStatus()
        
        checkOnBoardingStatus()
    }
// MARK: - Table View Data Source * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        return UITableViewCell()
//    }
    
//MARK: Table View Delegate * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
//MARK: - Helpers * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    private func checkOnBoardingStatus() {
        
        if MUser.currentUser() != nil {
            
            if MUser.currentUser()!.onBoard {
                
                finishRegistrationButtonOutlet.setTitle("Cuenta Activa", for: .normal)
                finishRegistrationButtonOutlet.isEnabled = false
                
            } else {
                
                finishRegistrationButtonOutlet.setTitle("Terminar Registración", for: .normal)
                finishRegistrationButtonOutlet.isEnabled = true
                finishRegistrationButtonOutlet.tintColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            }
            
            purchaseHistoryButtonOutlet.isEnabled = true
            
        } else {
            
            finishRegistrationButtonOutlet.setTitle("Terminar Sesión", for: .normal)
            finishRegistrationButtonOutlet.isEnabled = false
            purchaseHistoryButtonOutlet.isEnabled = false
        }
        
    }
    
    private func checkLogInStatus() {
        
        if MUser.currentUser() == nil {
            
            createRightBarButton(title: "Iniciar Sesión")
            
        } else {
            
            createRightBarButton(title: "Editar")
            
        }
    }
    
    private func createRightBarButton (title: String) {
        
        editBarButtonOutlet = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(rightBarButtonItemPressed))
        
        self.navigationItem.rightBarButtonItem = editBarButtonOutlet
        
    }
    
//MARK: IBActions * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    @objc func rightBarButtonItemPressed() {
        
        if editBarButtonOutlet.title == "Iniciar Sesión" {
            
            showLogInView()
            
        } else {
            
            goToEditProfile()
            
        }
        
    }
    
    private func showLogInView() {
        
        let logInView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "logInView")
        
        self.present(logInView, animated: true, completion: nil)
        
    }
    
// MARK: - Navigation * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//    }

    private func goToEditProfile() {
        
        print("Editar Perfil")
        performSegue(withIdentifier: "profileToEditSeg", sender: self)
    }
    
    private func loadAdminUserInfo() {
           
           if MUser.currentUser() != nil {
               
               let currentUser = MUser.currentUser()!
            
                print(currentUser.isAdmin)

               if currentUser.isAdmin == true {
                   
                   self.administratorDashboard.isEnabled = true
                
                self.administrativeDashboardCell.isHidden = false
                
                   print("CUENTA DE ADMINISTRADOR")
                   
               } else {
                   
                   self.administratorDashboard.isEnabled = false
                
                self.administrativeDashboardCell.isHidden = false
                
                   print("CUENTA DE USUARIO")
               }
               
               //print(currentUser.isAdmin)
           }
       }
}
