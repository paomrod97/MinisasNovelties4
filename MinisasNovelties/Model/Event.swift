//
//  Item.swift
//  MinisasNovelties
//
//  Created by Paola Rodriguez on 3/17/21.
//  Copyright @ 2021 Paola Rodriguez. All rights reserved.
//

import Foundation
import UIKit
import InstantSearchClient

class Event {
    
//MARK: - Variables * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    var eventId: String!
    var title: String!
    var description: String!
    var date: String!
    
//MARK: - Initializers * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

    init() {
        
    }
    
    init(_dictionary: NSDictionary) {
        
        eventId = _dictionary[kEVENTID] as? String
        title = _dictionary[kEVENTTITLE] as? String
        description = _dictionary[kEVENTDESCRIPTION] as? String
        date = _dictionary[kEVENTDATE] as? String
        
    }

}

//MARK: - Save Items Func * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

func saveEventToFirestore (_ event: Event) {
    FirebaseReference(.Event).document(event.eventId).setData(eventDictionaryFrom(event) as! [String: Any])
}

//MARK: - Helper Functions * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

func eventDictionaryFrom(_ event: Event) -> NSDictionary {
   
    return NSDictionary(objects: [event.eventId, event.title, event.description, event.date], forKeys: [kEVENTID as NSCopying, kEVENTTITLE as NSCopying, kEVENTDESCRIPTION as NSCopying, kEVENTDATE as NSCopying])
    
}

//func allEvents(_ completion: @escaping (_ eventArray: [Event]) -> Void) {
func downloadAllEventsFromFirebase (completion: @escaping (_ eventArray: [Event]) -> Void) {

    var eventArray: [Event] = []

//print(eventArray)
    //FirebaseReference(.Event).getDocuments { (snapshot, error) in
    FirebaseReference(.Event).getDocuments { (snapshot, error) in

        guard let snapshot = snapshot else {
            completion(eventArray)
            return
        }

        if !snapshot.isEmpty {

            //for eventDict in snapshot.documents {

               // eventArray.append(Item(_dictionary: itemDict.data() as NSDictionary))
            //}
        }
//
        completion(eventArray)
    }
//
}

//func downloadAllItemsFromFirebase(completion: @escaping (_ itemArray: [Item]) -> Void) {
//
//    var itemArray: [Item] = []
//
//    FirebaseReference(.Items).getDocuments { (snapshot, error) in
//
//        guard let snapshot = snapshot else {
//            completion(itemArray)
//            return
//        }
//
//        if !snapshot.isEmpty {
//
//            for itemDict in snapshot.documents {
//
//                itemArray.append(Item(_dictionary: itemDict.data() as NSDictionary))
//            }
//        }
//
//        completion(itemArray)
//    }
//
//}


//MARK: Download Func * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

//func downloadItemsFromFirebase(_ withCategoryId: String, completion: @escaping (_ itemArray: [Item]) -> Void) {
//
//    var itemArray: [Item] = []
//
//    FirebaseReference(.Items).whereField(kCATEGORYID, isEqualTo: withCategoryId).getDocuments { (snapshot, error) in
//
//        guard let snapshot = snapshot else {
//            completion(itemArray)
//            return
//        }
//
//        if !snapshot.isEmpty {
//
//            for itemDict in snapshot.documents {
//
//                itemArray.append(Item(_dictionary: itemDict.data() as NSDictionary))
//            }
//        }
//
//        completion(itemArray)
//    }
//
//}
//
////MARK: DOWNLOAD ALL ITEMS * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
//
//func downloadAllItemsFromFirebase(completion: @escaping (_ itemArray: [Item]) -> Void) {
//
//    var itemArray: [Item] = []
//
//    FirebaseReference(.Items).getDocuments { (snapshot, error) in
//
//        guard let snapshot = snapshot else {
//            completion(itemArray)
//            return
//        }
//
//        if !snapshot.isEmpty {
//
//            for itemDict in snapshot.documents {
//
//                itemArray.append(Item(_dictionary: itemDict.data() as NSDictionary))
//            }
//        }
//
//        completion(itemArray)
//    }
//
//}
//
////MARK: - Download Func Basket * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
//
//func downloadItems(_ withIds: [String], completion: @escaping (_ itemArray: [Item]) -> Void) {
//
//    var count = 0
//        var itemArray: [Item] = []
//
//        if withIds.count > 0 {
//
//            for itemId in withIds {
//
//                FirebaseReference(.Items).document(itemId).getDocument { (snapshot, error) in
//
//                    guard let snapshot = snapshot else {
//                        completion(itemArray)
//                        return
//                    }
//
//                    if snapshot.exists {
//
//                        itemArray.append(Item(_dictionary: snapshot.data()! as NSDictionary))
//                        count += 1
//
//                    } else {
//                        completion(itemArray)
//                    }
//
//                    if count == withIds.count {
//                        completion(itemArray)
//                    }
//
//                }
//            }
//        } else {
//            completion(itemArray)
//        }
//
//
//    }
//
////MARK: - Algolia Funcs * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
//
//func saveItemToAlgolia(item: Item) {
//
//    let index = AlgoliaService.shared.index
//
//    let itemToSave = itemDictionaryFrom(item) as! [String: Any]
//
//    index.addObject(itemToSave, withID: item.id, requestOptions: nil) { (content, error) in
//
//        if error != nil {
//
//            print("Error saving to Algolia", error!.localizedDescription)
//
//        } else {
//
//            print("Added to Algolia")
//
//        }
//    }
//}
//
//func searchAlgolia(searchString: String, completion: @escaping (_ itemArray: [String]) -> Void) {
//
//    let index = AlgoliaService.shared.index
//
//    var resultIds: [String] = []
//
//    let query = Query(query: searchString)
//
//    query.attributesToRetrieve = ["name", "description"]
//
//    index.search(query) { (content, error) in
//
//        if error == nil {
//
//            let cont = content!["hits"] as! [[String: Any]]
//
//            resultIds = []
//
//            for result in cont {
//
//                resultIds.append(result["objectID"] as! String)
//
//            }
//
//            completion(resultIds)
//
//        } else {
//
//            print("Error Algolia Search", error!.localizedDescription)
//            completion(resultIds)
//
//        }
//    }
//}
//
////MARK: - Update items * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
//
//func updateItemsInFirestore(_ item: Item, withValues: [String : Any], completion: @escaping (_ error: Error?) -> Void) {
//
//    FirebaseReference(.Items).document(item.id).updateData(withValues) { (error) in
//        completion(error)
//    }
//
//}
//
////MARK: - Delete items * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
////
////func deleteItemInFirestore(_ item: Item, withValues: [String : Any], completion: @escaping (_ error: Error?) -> Void) {
////
////        FirebaseReference(.Items).document(item.id).delete() { (error) in
////            completion(error)
////        }
////    }
//
//func deleteItemInFirestore(_ itemId: String, completion: @escaping (_ itemArray: [Item]) -> Void) {
//
//    var itemArray: [Item] = []
//
//    print ("before function")
//    print(itemId)
//    print("delete")
//
//    FirebaseReference(.Items).document(itemId).delete() { err in
//        if let err = err {
//            print("Error removing document: \(err)")
//        } else {
//            print("Document successfully removed!")
//        }
//    }
//
//    print("after function")
//    print(itemId)
//}

