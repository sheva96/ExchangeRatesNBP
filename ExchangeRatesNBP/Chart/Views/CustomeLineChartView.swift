//
//  CustomeLineCharView.swift
//  ExchangeRatesNBP
//
//  Created by Yevhen Shevchenko on 17.02.2021.
//

import Foundation
import Charts

class CustomeLineChartView: LineChartView {
    
    var dates: [String]?
    
    override var marker: IMarker? {
        get {
            BalloonMarkerView(data: dates ?? [])
        }
        set {
            super.marker = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        drawMarkers = true
        pinchZoomEnabled = false
        doubleTapToZoomEnabled = false
        noDataTextColor = .customeLightGrey
        noDataFont = .systemFont(ofSize: 20, weight: .thin)
        backgroundColor = .clear
        
        xAxis.drawGridLinesEnabled = false
        xAxis.labelPosition = .bottom
        xAxis.labelTextColor = .customeLightGrey
        
        setExtraOffsets(left: 25, top: 0, right: 25, bottom: 0)
        legend.form = .circle
        legend.textColor = .gold
        legend.font = .systemFont(ofSize: 17)
        legend.horizontalAlignment = .center
        legend.verticalAlignment = .top
        
        leftAxis.valueFormatter = YAxisValueFormatter()
        leftAxis.labelTextColor = .customeLightGrey
        leftAxis.drawLabelsEnabled = false
        
        rightAxis.drawLabelsEnabled = false
        rightAxis.valueFormatter = YAxisValueFormatter()
        rightAxis.labelTextColor = .customeLightGrey
        
        animate(xAxisDuration: 1, easingOption: .easeInOutBack)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
