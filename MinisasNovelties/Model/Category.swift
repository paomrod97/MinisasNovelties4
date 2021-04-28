//
//  Category.swift
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

class Category {
    
//MARK: Variables * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    var id: String
    var name: String
    var image: UIImage?
    var imageName: String?
    
//MARK: - Initializers * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
//    init() {
//        
//    }
    
    init(_name: String, _imageName: String) {
        
    id = ""
    name = _name
    image = UIImage(named: _imageName)
    imageName = _imageName
   
        
    }
    
    init(_dictionary: NSDictionary) {
        id = _dictionary[kOBJECTID] as! String
        name = _dictionary[kNAME] as! String
        image = UIImage(named: _dictionary[kIMAGENAME] as? String ?? "")
    }
    
}

// MARK: Download Category From Firebase * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

func downloadCategoriesFromFirebase(completion: @escaping (_ categoryArray: [Category]) -> Void) {
    
    var categoryArray: [Category] = []
    
    FirebaseReference(.Category).getDocuments { (snapshot, error) in
        
        guard let snapshot = snapshot else {
            completion(categoryArray)
            return
        }
        
        if !snapshot.isEmpty {
            
            for categoryDictionary in snapshot.documents {
                //print("created new category with")
                categoryArray.append(Category(_dictionary: categoryDictionary.data() as NSDictionary))
            }
            
        }
        
        completion(categoryArray)
    }
}

// MARK: Save Category Functions * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

func saveCategoryToFirebase(_ category: Category) {

    let id = UUID().uuidString
    category.id = id

    FirebaseReference(.Category).document(category.id).setData(categoryDictionaryFrom(category) as! [String: Any])

}

// MARK: Helpers * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

func categoryDictionaryFrom(_ category: Category) -> NSDictionary {
    
    return NSDictionary(objects: [category.id, category.name, category.imageName], forKeys: [kOBJECTID as NSCopying, kNAME as NSCopying, kIMAGENAME as NSCopying])
    
}

// Use only one time
//func createCategorySet() {
//
//    let mostradores = Category(_name: "Mostradores", _imageName: "mostradores")
//
//    let utensilios = Category(_name: "utensilios", _imageName: "utensilios")
//
//    let moldes = Category(_name: "moldes", _imageName: "Umoldes")
//
//    let ingredientes = Category(_name: "Ingredientes", _imageName: "ingredientes")
//
//    let arrayOfCategories = [mostradores, utensilios, moldes, ingredientes]
//
//    for category in arrayOfCategories {
//
//        saveCategoryToFirebase(category)
//    }
//}


