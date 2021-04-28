//
//  FirebaseCollectionReference.swift
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

enum FCollectionReference: String {
    case User
    case Category
    case Items
    case Basket
    case Event
    
}

func FirebaseReference (_ collectionReference: FCollectionReference) -> CollectionReference {
   
    return Firestore.firestore().collection(collectionReference.rawValue)
}
