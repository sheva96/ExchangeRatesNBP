//
//  ContentViewModel.swift
//  ExchangeRatesNBP
//
//  Created by Yevhen Shevchenko on 11.02.2021.
//

import Foundation


protocol InfoViewViewModelProtocol {
    var code: String { get set }
    var value: String { get set }
}

class InfoViewViewModel: InfoViewViewModelProtocol {
    
    var code: String
    var value: String
    
    required init(code: String, value: String) {
        self.code = code
        self.value = value
    }
}
