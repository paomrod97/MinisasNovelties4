//
//  Constants.swift
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

enum Constants {
    
    static let pulishableKey = "pk_test_51IdahWCn0OfKsdgfBjYnjYrOidPhwtpMu6WbB11nB75SlhjdVqrxWEIFpRkNF3ZEjx7uJsXCSchr0r4J18yo0y3k00D5y1G1KO"
    static let baseURLString = "https://minisasnovelties.herokuapp.com"
    //"http://localhost:3000/"
    static let defaultCurrency = "usd"
    static let defaultDescription = "Compra de Minisas Novelties"
    
}

//IDS and Keys
public let kFILEREFERENCE = "gs://minisasnovelties.appspot.com"
public let kALGOLIA_APP_ID = "LVDCHY5HB8"
public let kALGOLIA_SEARCH_KEY = "0ac039525870cde69f0eb79cfc9df485"
public let kALGOLIA_ADMIN_KEY = "c4be040e927b164049572302a5211c51"

// MARK: Firebase Header

public let kUSER_PATH = "User"
public let kCATEGORY_PATH = "Category"
public let kITEMS_PATH = "Items"
public let kBASKET_PATH = "Basket"

// MARK: Category
public let kNAME = "name"
public let kIMAGENAME = "imageName"
public let kOBJECTID = "objectId"

//MARK: Items
public let kCATEGORYID = "categoryId"
public let kDESCRIPTION = "description"
public let kPRICE = "price"
public let kIMAGELINKS = "imageLinks"
public let kQUANTITY = "quantity"
public let kCLIENTQUANTITY2 = "clientQuantity2"

//MARK: Basket
public let kOWNERID = "ownerId"
public let kITEMIDS = "itemIds"
public let kCLIENTQUANTITY = "clientQuantity"


//MARK: User
public let kEMAIL = "email"
public let kFIRSTNAME = "firstName"
public let kLASTNAME = "lastName"
public let kFULLNAME = "fullName"
public let kCURRENTUSER = "currentUser"
public let kFULLADDRESS = "fullAddress"
public let kONBOARD = "onBoard"
public let kISADMIN = "isAdmin"
public let kPURCHASEDITEMSIDS = "purchasedItemsIds"

//MARK: Event
public let kEVENTID = "eventId"
public let kEVENTTITLE = "title"
public let kEVENTDESCRIPTION = "description"
public let kEVENTDATE = "date"
