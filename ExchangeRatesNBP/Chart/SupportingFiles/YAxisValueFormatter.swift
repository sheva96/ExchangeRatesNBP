//
//  YAxisValueFormatter.swift
//  ExchangeRatesNBP
//
//  Created by Yevhen Shevchenko on 19.02.2021.
//

import Foundation
import Charts

class YAxisValueFormatter: NSObject, IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        String(format: "%.4f", value)
    }
}
