//
//  HelperFunctions.swift
//  MinisasNovelties
//
//  Created by Paola Rodriguez on 3/22/21.
//

import Foundation

func convertToCurrency(_ number: Double) -> String {
    
    
    let currencyFormatter = NumberFormatter()
    
    currencyFormatter.usesGroupingSeparator = true
    
    currencyFormatter.numberStyle = .currency
    
    currencyFormatter.locale = Locale.current

    return currencyFormatter.string(from: NSNumber(value: number))!
    
   
}
