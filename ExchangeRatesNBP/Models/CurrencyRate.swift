//
//  CurrencyRate.swift
//  ExchangeRatesNBP
//
//  Created by Yevhen Shevchenko on 02.03.2021.
//

import Foundation

struct CurrencyRate: Decodable {
    let no: String?
    let effectiveDate: String?
    let mid: Double?
}
