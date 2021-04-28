//
//  AlgoliaService.swift
//  MinisasNovelties
//
//  Created by Paola Rodriguez on 4/6/21.
//  Copyright @ 2021 Paola Rodriguez. All rights reserved.
//

import Foundation
import InstantSearchClient

class AlgoliaService {
    
    static let shared = AlgoliaService()
    
    let client = Client(appID: kALGOLIA_APP_ID, apiKey: kALGOLIA_ADMIN_KEY)
    let index = Client(appID: kALGOLIA_APP_ID, apiKey: kALGOLIA_ADMIN_KEY).index(withName: "items_Name")
    
    private init() {}
}

