//
//  EditItemViewController.swift
//  MinisasNovelties
//
//  Created by Paola Rodriguez on 4/28/21.
//

import UIKit
import JGProgressHUD

class EditItemViewController: UIViewController {

//MARK: - IBOutlets * * * * * * * * * * * * * * * * * * * * * * * * * * 
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var priceTextField: UITextField!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var quantityTextField: UITextField!
    
    @IBOutlet weak var categoryPicker: UIPickerView!
    
//MARK: - Variables * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    var item: Item!
    
    var itemArray: [Item] = []
    
    let hud = JGProgressHUD(style: .light)
    
//MARK: - View Lifecycle * * * * * * * * * * * * * * * * * * * * * * * *
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadItemInfo()
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func savePressedButtonOutlet(_ sender: Any) {
//        
//        dismmissKeyboard()
//        
//        if textFieldsHaveText() {
//            
//            let withValues = [kNAME: titleTextField.text!, kPRICE: priceTextField.text!, kDESCRIPTION: descriptionTextView.text!, kQUANTITY: quantityTextField.text!]
//            
//            func editItem(_ rowID: Int) {
//                
//                updateCurrentItemInFirestore(self.itemArray[rowID], withValues: kITEMIDS)  { (error) in
//               
//            if error != nil {
//                  
//                print("Error editing item", error)
//                //print("Error updating inventory", error.localizedDescription)
//                            
//                }
//            }
//            
//            print(self.itemArray[rowID].id!)
//            
//            self.itemArray.remove(at: rowID)
//            
//            //self.tableView.reloadData()
//            }
//            
////            updateCurrentItemInFirestore(item, withValues: withValues) { (error) in
////
////                if error == nil {
////
////                    self.hud.textLabel.text = "Actualizado"
////                    self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
////                    self.hud.show(in: self.view)
////                    self.hud.dismiss(afterDelay: 2.0)
////
////                } else {
////
////                    print("Error actualizando artículo", error!.localizedDescription)
////                    self.hud.textLabel.text = error!.localizedDescription
////                    self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
////                    self.hud.show(in: self.view)
////                    self.hud.dismiss(afterDelay: 2.0)
////
////                }
////
////            }
////
////        } else {
////
////            hud.textLabel.text = "Todos los campos son requeridos"
////            hud.indicatorView = JGProgressHUDErrorIndicatorView()
////            hud.show(in: self.view)
////            hud.dismiss(afterDelay: 2.0)
////
//          }
     }
    
    // * * * * * * * * * * * * *
//    func editItem(_ rowID: Int) {
//
//        updateCurrentItemInFirestore(self.itemArray[rowID], withValues: [String : Any])  { (error) in
//
//    if error != nil {
//
//        print("Error editing item", error)
//        //print("Error updating inventory", error.localizedDescription)
//
//        }
//    }
//
//    print(self.itemArray[rowID].id!)
//
//    self.itemArray.remove(at: rowID)
//
//    //self.tableView.reloadData()
//    }
    // * * * * * * * * * * * * * * *  * * * * *
    
//MARK: Update User Interface * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
        
        private func loadItemInfo() {
            
            if item != nil {
                                
                titleTextField.text = item.name
                
                priceTextField.text = convertToCurrency(item.price)
                
                descriptionTextView.text = item.description
                
                quantityTextField.text = item.quantity
                
                
            }
        }
    
//    private func setUpUI(){
//
//        if item != nil {
//            self.title = item.name
//            nameLabel.text = item.name
//            priceLabel.text = convertToCurrency(item.price)
//            descriptionTextView.text = item.description
//            //counterLabel.text = item.quantity
//            itemNumberLabel.text = "Total en inventario: \(item.quantity!)"
//        }

//MARK: - Helper Functions * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
        
        private func dismmissKeyboard() {
            
            self.view.endEditing(false)
            
        }
        
        private func textFieldsHaveText() -> Bool {
            
            return titleTextField.text != "" && priceTextField.text != "" && descriptionTextView.text != "" && quantityTextField.text != ""
            
        }
        
}
