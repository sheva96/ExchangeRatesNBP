//
//  Currency.swift
//  ExchangeRatesNBP
//
//  Created by Yevhen Shevchenko on 17.02.2021.
//

import Foundation

struct Currency: Decodable {
    let table: String?
    let currency: String?
    let code: String?
    let rates: [CurrencyRate]?
}
