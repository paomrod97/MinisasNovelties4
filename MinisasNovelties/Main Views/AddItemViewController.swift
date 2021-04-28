//
//  AddItemViewController.swift
//  MinisasNovelties
//
//  Created by Paola Rodriguez on 3/17/21.
//  Copyright @ 2021 Paola Rodriguez. All rights reserved.
//

import UIKit
import Gallery
import JGProgressHUD
import NVActivityIndicatorView

class AddItemViewController: UIViewController, UITextViewDelegate {

//MARK: - IBOutlets * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var priceTextField: UITextField!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var categoryPicker: UIPickerView!
    
    @IBOutlet weak var quantityTextField: UITextField!
    
    
//MARK: - Variables * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    var selectCategory = 0
    
    var category: Category!
    
    var categoryArray: [Category] = []

    var gallery: GalleryController!
    
    let hud = JGProgressHUD(style: .light)
    
    var activityIndicator: NVActivityIndicatorView?
    
    var itemImages: [UIImage?] = []
    
//MARK: - View Lifecycle * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        categoryPicker.delegate = self
        categoryPicker.selectRow(1, inComponent: 0, animated: true)
        //loadCategories()
        
        descriptionTextView.delegate = self
        descriptionTextView.text = "Descripción"
        descriptionTextView.textColor = #colorLiteral(red: 0.7685789466, green: 0.7686592937, blue: 0.776710391, alpha: 1)
        
        textViewDidBeginEditing(descriptionTextView)
        
        textViewDidEndEditing(descriptionTextView)
        
        //print(category.id)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60, height: 60), type: .ballPulse, color: #colorLiteral(red: 0.329379946, green: 0.3294321001, blue: 0.3293685317, alpha: 1), padding: nil)
        
           loadCategories()
        
           activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60, height: 60), type: .ballPulse, color: #colorLiteral(red: 0.329379946, green: 0.3294321001, blue: 0.3293685317, alpha: 1), padding: nil)
        
    }
    
//MARK: - IBActions * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

    @IBAction func doneBarButtonItemPressed(_ sender: Any) {
        
        dismissKeyboard()
        
        if fieldAreCompleted() {
            saveToFirebase()
            //print("we have values")
        } else {
            //print("Error all fields are required" )

            self.hud.textLabel.text = "All fields are required"
            self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
            self.hud.show(in: self.view)
            self.hud.dismiss(afterDelay: 2.0)
        }
    }
    
    @IBAction func cameraButtonPressed(_ sender: Any) {
        itemImages = []
        showImageGallery()
    }
    
    @IBAction func backgroundTapped(_ sender: Any) {
        dismissKeyboard()
    }
    
//MARK: - Helper Functions * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    private func fieldAreCompleted() -> Bool {
        
        return (titleTextField.text != "" && priceTextField.text != "" && descriptionTextView.text != "" && quantityTextField.text != "")
    }
    
    private func dismissKeyboard() {
        
        self.view.endEditing(false)
    }
    
    private func popTheView() {
    
        self.navigationController?.popViewController(animated: true)
        
    }
    
//MARK: - Save Item * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    private func saveToFirebase() {
        
        showLoadingIndicator()
        
        let item = Item()
        item.id = UUID().uuidString
        item.name = titleTextField.text
        item.categoryId = self.categoryArray[self.selectCategory].id
        item.description = descriptionTextView.text
        item.price = Double(priceTextField.text!)
        item.quantity = String(quantityTextField.text!)
    
        
        if itemImages.count > 0 {
            
            uploadImages(images: itemImages, itemId: item.id) { (imageLinkArray) in
                item.imageLinks = imageLinkArray
                
                saveItemToFirestore(item)
                saveItemToAlgolia(item: item)
                
                self.hideLoadingIndicator()
                self.popTheView()
            
            }
        } else {
            
            saveItemToFirestore(item)
            saveItemToAlgolia(item: item)
            popTheView()
        }
    }
    
//MARK: - Activity Indicator * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
        
        private func showLoadingIndicator() {
            
            if activityIndicator != nil {
                self.view.addSubview(activityIndicator!)
                activityIndicator!.startAnimating()
            }
        }

        private func hideLoadingIndicator() {
            
            if activityIndicator != nil {
                activityIndicator!.removeFromSuperview()
                activityIndicator!.stopAnimating()
            }
        }

//MARK: - Show Gallery * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    private func showImageGallery() {
        self.gallery = GalleryController()
        self.gallery.delegate = self
        
        Config.tabsToShow = [.imageTab, .cameraTab]
        Config.Camera.imageLimit = 6
        
        self.present(self.gallery, animated: true, completion: nil)
    }
    
//MARK: - Text View Functions * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
        
    func textViewDidBeginEditing(_ descriptionTextView: UITextView) {
        if descriptionTextView.textColor == #colorLiteral(red: 0.7685789466, green: 0.7686592937, blue: 0.776710391, alpha: 1) {
            descriptionTextView.text = nil
            descriptionTextView.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
        
    func textViewDidEndEditing(_ descriptionTextView: UITextView) {
        if descriptionTextView.text.isEmpty {
            descriptionTextView.text = "Descripción"
            descriptionTextView.textColor = #colorLiteral(red: 0.7685789466, green: 0.7686592937, blue: 0.776710391, alpha: 1)
        }
    }
    
    private func loadCategories() {
        
        downloadCategoriesFromFirebase { (allCategories) in
            print("we have ", allCategories.count)
            self.categoryArray = allCategories
            self.categoryPicker.reloadComponent(0)
            
        }
    }
}

//MARK: - Extension * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

extension AddItemViewController: GalleryControllerDelegate {
    
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
        if images.count > 0 {
            
            Image.resolve(images: images) { (resolvedImages) in
                
                self.itemImages = resolvedImages
                
            }
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}

//MARK: - Extension * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

extension AddItemViewController: UIPickerViewDelegate,UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryArray.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryArray[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //self.selectedCat = row
        self.selectCategory = row
        print("Selected Row is \(row)")
        
    }
}
