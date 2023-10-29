//
//  Double+Currency.swift
//  RS Driver
//
//  Created by Filip Karas on 26/03/2023.
//

import Foundation

extension Double {
    
    public var currency: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.currency
        numberFormatter.currencySymbol = ""
        return numberFormatter.string(from: NSNumber(value: self))!.trimmingCharacters(in: .whitespacesAndNewlines) + " €"
    }
}
