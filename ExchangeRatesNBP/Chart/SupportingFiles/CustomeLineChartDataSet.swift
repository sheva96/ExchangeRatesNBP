//
//  DataSet.swift
//  ExchangeRatesNBP
//
//  Created by Yevhen Shevchenko on 17.02.2021.
//

import UIKit
import Charts

class CustomeLineChartDataSet: LineChartDataSet {
  
    override init(entries: [ChartDataEntry]?, label: String?) {
        super.init(entries: entries, label: label)
        
        drawHorizontalHighlightIndicatorEnabled = false
        drawCircleHoleEnabled = false
        drawCirclesEnabled = false
        drawValuesEnabled = false
        drawFilledEnabled = true
        mode = .cubicBezier
        highlightColor = .gold
        setColor(.gold)
        fillAlpha = 1
        lineWidth = 1
        
        let gradientColors = [UIColor.clear.cgColor, UIColor.gold.cgColor] as CFArray
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors, locations: nil)!
        
        fill = Fill(linearGradient: gradient, angle: 90)
    }
    
    required init() {
        super.init()
    }
}
