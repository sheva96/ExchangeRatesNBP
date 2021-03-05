//
//  Extension + String.swift
//  ExchangeRatesNBP
//
//  Created by Yevhen Shevchenko on 16.01.2021.
//

import UIKit

extension String {
    
    static func convert(from date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "MM-dd"
        return  dateFormatter.string(from: date!)
    }
    
    static func convertNumberFormatter(_ value: Double) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.usesGroupingSeparator = false
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter.string(from: NSNumber(value: value))
    }
}

