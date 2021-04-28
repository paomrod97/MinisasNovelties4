//
//  AddCategoryViewController.swift
//  MinisasNovelties
//
//  Created by Paola Rodriguez on 3/17/21.
//  Copyright @ 2021 Paola Rodriguez. All rights reserved.
//

import UIKit
import Gallery
import JGProgressHUD
import NVActivityIndicatorView

class AddCategoryViewController: UIViewController {

//MARK: - IBOutlets * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

    @IBOutlet weak var titleTextField: UITextField!

////MARK: - Variables * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
//
//    var category: Category!
//
//    var categoryArray: [Category] = []
//
//    var gallery: GalleryController!
//    let hud = JGProgressHUD(style: .light)
//
//    var activityIndicator: NVActivityIndicatorView?
//
//    var itemImages: [UIImage?] = []
//
////MARK: - View Lifecycle * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        //print(category.id)
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//           activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60, height: 60), type: .ballPulse, color: #colorLiteral(red: 0.329379946, green: 0.3294321001, blue: 0.3293685317, alpha: 1), padding: nil)
//
//    }
//
//MARK: - IBActions * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
//
    @IBAction func doneBarButtonItemPressed(_ sender: Any) {
//
//        saveCategory()
////
////        dismissKeyboard()
////
////        if fieldAreCompleted() {
////            saveToFirebase()
////            //print("we have values")
////        } else {
////            //print("Error all fields are required")
////
////            self.hud.textLabel.text = "All fields are required"
////            self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
////            self.hud.show(in: self.view)
////            self.hud.dismiss(afterDelay: 2.0)
////        }
   }
////
//    @IBAction func cameraButtonPressed(_ sender: Any) {
//        itemImages = []
//        showImageGallery()
//    }
//
//    @IBAction func backgroundTapped(_ sender: Any) {
//        dismissKeyboard()
//    }
//
////MARK: - Helper functions * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
//
//    private func fieldAreCompleted() -> Bool {
//
//        return (titleTextField.text != "")
//    }
//
//    private func dismissKeyboard() {
//
//        self.view.endEditing(false)
//    }
//
//    private func popTheView() {
//
//        self.navigationController?.popViewController(animated: true)
//
//    }
//

//MARK: - Save Category * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

//        private func saveCategory() {
//
//            //showLoadingIndicator()
//
//            let category = Category()
//            category.id = UUID().uuidString
//            category.name = titleTextField.text!
//            category.image = nil
//            category.imageName = nil
//
//            //if itemImages.count > 0 {
//
////                uploadImages(images: itemImages, itemId: category.id) { (imageLinkArray) in
////                    category.imageLinks = imageLinkArray
////
//            saveCategoryToFirebase(category)
////                    saveItemToAlgolia(category: category)
////
////                    self.hideLoadingIndicator()
////                    self.popTheView()
//
//                }
//            } else {
//
//                saveCategoryToFirestore(category)
////                saveItemToAlgolia(category: category.id)
////                popTheView()
//            }
//        }

////MARK: - Activity Indicator * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
//
//        private func showLoadingIndicator() {
//
//            if activityIndicator != nil {
//                self.view.addSubview(activityIndicator!)
//                activityIndicator!.startAnimating()
//            }
//        }
//
//        private func hideLoadingIndicator() {
//
//            if activityIndicator != nil {
//                activityIndicator!.removeFromSuperview()
//                activityIndicator!.stopAnimating()
//            }
//        }
//
////MARK: - Show Gallery * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
//
//        private func showImageGallery() {
//                self.gallery = GalleryController()
//                self.gallery.delegate = self
//
//                Config.tabsToShow = [.imageTab, .cameraTab]
//                Config.Camera.imageLimit = 6
//
//                self.present(self.gallery, animated: true, completion: nil)
//        }
//
////MARK: - Text View Functions * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
//
//        func textViewDidBeginEditing(_ descriptionTextView: UITextView) {
//            if descriptionTextView.textColor == #colorLiteral(red: 0.7685789466, green: 0.7686592937, blue: 0.776710391, alpha: 1) {
//               descriptionTextView.text = nil
//               descriptionTextView.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//            }
//        }
//
//        func textViewDidEndEditing(_ descriptionTextView: UITextView) {
//            if descriptionTextView.text.isEmpty {
//               descriptionTextView.text = "Descripción"
//               descriptionTextView.textColor = #colorLiteral(red: 0.7685789466, green: 0.7686592937, blue: 0.776710391, alpha: 1)
//            }
//        }
//    }
//
////MARK: - Extension * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
//
//extension AddItemViewController: GalleryControllerDelegate {
//
//        func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
//
//            if images.count > 0 {
//
//                Image.resolve(images: images) { (resolvedImages) in
//
//                    self.itemImages = resolvedImages
//
//                }
//            }
//
//            controller.dismiss(animated: true, completion: nil)
//        }
//
//        func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
//            controller.dismiss(animated: true, completion: nil)
//        }
//
//        func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
//            controller.dismiss(animated: true, completion: nil)
//        }
//
//        func galleryControllerDidCancel(_ controller: GalleryController) {
//            controller.dismiss(animated: true, completion: nil)
//        }
//
//    }
//


}
