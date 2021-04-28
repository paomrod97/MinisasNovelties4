//
//  CategoryCollectionViewController.swift
//  MinisasNovelties
//
//  Created by Paola Rodriguez on 2/28/21.
//  Copyright @ 2021 Paola Rodriguez. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

private let reuseIdentifier = "Cell"

class CategoryCollectionViewController: UICollectionViewController {
    
//MARK: - IBOutlets * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    @IBOutlet weak var addItem: UIBarButtonItem!
    
    @IBOutlet weak var inventory: UIBarButtonItem!
    
//MARK: - Variables * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    var categoryArray: [Category] = []
    
    private let sectionInsets = UIEdgeInsets(top: 20.0, left: 10.0, bottom: 20.0, right: 10.0)
    
    private let itemsPerRow: CGFloat = 2
    
//MARK: - View Lifecycle * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadAdminUserInfo()
        
//        loadUserInfo()
        
        //print(self.categoryArray.objectId)
        
//         createCategorySet()
        
//        downloadCategoriesFromFirebase  { (allCategories) in
//            print("callback is completed")
//        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadCategories()
    }
    

// MARK: - UICollectionViewDataSource * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return categoryArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CategoryCollectionViewCell
         
        cell.generateCell(categoryArray[indexPath.row])
        return cell
//        return UICollectionViewCell()
    }
    
//MARK: - UICollectionViewDelegate * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "categoryToItemsSeg", sender: categoryArray[indexPath.row])
        
    }
    
//MARK: - Download categories * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    private func loadCategories() {
        
        downloadCategoriesFromFirebase { (allCategories) in
//            print("we have ", allCategories.count)
            self.categoryArray = allCategories
            self.collectionView.reloadData()
        }
    }

//MARK: - Navigation * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "categoryToItemsSeg" {
            let vc = segue.destination as! ItemsTableViewController
            vc.category = sender as! Category
            
            
        }

    }
    
    private func loadAdminUserInfo() {
        
        if MUser.currentUser() != nil {
            
            let currentUser = MUser.currentUser()!
            
            print(currentUser.isAdmin)

            if currentUser.isAdmin == true {
                
//                self.addItem.isEnabled = true
                
                //self.inventory.isEnabled = true
                
                print("CUENTA DE ADMINISTRADOR")
                
            } else {
                
      //          self.addItem.isEnabled = false
                
        //        self.inventory.isEnabled = false
                
                print("CUENTA DE USUARIO")
            }
            
            //print(currentUser.isAdmin)
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
//                self.addCategory.isEnabled = true
//
//                self.inventory.isEnabled = true
//                print("isAdmin")
//
//            } else {
//
//                addCategory.isEnabled = false
//
//                self.inventory.isEnabled =
//                    false
//                print("isUser")
//            }
//
//            print(currentUser.isAdmin)
//
//        }
//    }
// MARK: - UICollectionViewDelegate * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

//MARK: - Extension * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

extension CategoryCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> UIEdgeInsets{
        
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGFloat {
        
        return sectionInsets.left
    }
    
}
