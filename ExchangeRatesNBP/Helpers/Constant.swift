//
//  Constant.swift
//  ExchangeRatesNBP
//
//  Created by Yevhen Shevchenko on 02.03.2021.
//

import Foundation

struct Constant {
    
    enum TabBarIcon: String, CaseIterable {
        case euro
        case chart
        case setting
    }
    
    struct ControllerTitle {
        static let converter = "Kalkulator"
        static let settings = "Ustawenia"
        static let charts = "Wykresy"
        static let currencies = "Waluty"
    }
}
