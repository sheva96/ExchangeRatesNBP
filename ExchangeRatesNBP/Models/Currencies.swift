//
//  ExchangeRate.swift
//  ExchangeRatesNBP
//
//  Created by Yevhen Shevchenko on 04.02.2021.
//

import Foundation

struct Currencies: Codable {
    let table: String?
    let no: String?
    let effectiveDate: String?
    let rates: [Rate]?
}
