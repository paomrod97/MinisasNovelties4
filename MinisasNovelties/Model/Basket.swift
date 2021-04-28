//
//  Basket.swift
//  Market
//
//  Created by Paola Rodriguez on 24/03/2021.
//  Copyright © 2021 Paola Rodriguez. All rights reserved.
//

import Foundation

class Basket {
    
//MARK: - Variables * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    var id: String!
    var ownerId: String!
    var itemIds: [String]!
    var clientQuantity: Int!
    
//MARK: - Initializers * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    init() {
    }
    
    init(_dictionary: NSDictionary) {
        id = _dictionary[kOBJECTID] as? String
        ownerId = _dictionary[kOWNERID] as? String
        itemIds = _dictionary[kITEMIDS] as? [String]
        clientQuantity = _dictionary[kCLIENTQUANTITY] as? Int
    }
}

//MARK: - Download items * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

func downloadBasketFromFirestore(_ ownerId: String, completion: @escaping (_ basket: Basket?)-> Void) {

    FirebaseReference(.Basket).whereField(kOWNERID, isEqualTo: ownerId).getDocuments { (snapshot, error) in

        guard let snapshot = snapshot else {

            completion(nil)
            return
        }

        if !snapshot.isEmpty && snapshot.documents.count > 0 {
            let basket = Basket(_dictionary: snapshot.documents.first!.data() as NSDictionary)
            completion(basket)
        } else {
            completion(nil)
        }
    }
}

//MARK: - Save to Firebase * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

func saveBasketToFirestore(_ basket: Basket) {

    FirebaseReference(.Basket).document(basket.id).setData(basketDictionaryFrom(basket) as! [String: Any])
}

//MARK: - Helper functions * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

func basketDictionaryFrom(_ basket: Basket) -> NSDictionary {

    return NSDictionary(objects: [basket.id, basket.ownerId, basket.itemIds, basket.clientQuantity], forKeys: [kOBJECTID as NSCopying, kOWNERID as NSCopying, kITEMIDS as NSCopying, kCLIENTQUANTITY as NSCopying])
}

//MARK: - Update basket * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

func updateBasketInFirestore(_ basket: Basket, withValues: [String : Any], completion: @escaping (_ error: Error?) -> Void) {

    FirebaseReference(.Basket).document(basket.id).updateData(withValues) { (error) in
        completion(error)
    }
}
