//
//  ChartViewModel.swift
//  ExchangeRatesNBP
//
//  Created by Yevhen Shevchenko on 17.02.2021.
//

import Foundation
import Charts

protocol ChartViewModelProtocol {
    var items: [String] { get }
    var code: String? { get }
    var data: Box<[LineChartData]> { get set }
    var dates: Box<[String]> { get set }
}

class ChartViewModel: ChartViewModelProtocol {
    
    var items =  ["7 dni", "30 dni", "90 dni"]
    
    var code: String?
    
    var data: Box<[LineChartData]> = Box(value: [])
    var dates: Box<[String]> = Box(value: [])
    
    private var entries: [ChartDataEntry]? {
        didSet {
            guard let entries = entries else { return }

            data.value = [
                createChartData(entries: entries.suffix(7)),
                createChartData(entries: entries.suffix(30)),
                createChartData(entries: entries)
            ]
        }
    }
    
    // MARK: - Init
    
    init(code: String) {
        self.code = fetchCodeText(code: code)
        sendRequset(code: code)
    }
    
    // MARK: - Private methods
    
    private func createChartData(entries: [ChartDataEntry]?) -> LineChartData {
        let dataSet = CustomeLineChartDataSet(entries: entries, label: code)
        return LineChartData(dataSet: dataSet)
    }
    
    private func fetchCodeText(code: String) -> String? {
        guard let code = Code(rawValue: code.lowercased()) else { return nil }

        switch code {
        case .huf, .jpy, .isk, .clp, .inr, .krw:
            return "100 \(code.rawValue.uppercased()) - kurs średni"
        case .idr:
            return "1000 \(code.rawValue.uppercased()) - kurs średni"
        default:
            return "1 \(code.rawValue.uppercased()) - kurs średni"
        }
    }
    
    private func sendRequset(code: String) {
        let url = URLS.fetchRateOfCurrency(at: code)
        
        NetworkManager.shared.fetchData(url) { (data: Currency?) in
            guard let rates = data?.rates else { return }
            
            self.entries = rates.enumerated().map {
                ChartDataEntry(x: Double($0.offset), y: $0.element.mid ?? 0)
            }
            
            self.dates.value = rates.map { String.convert(from: $0.effectiveDate ?? "") }
        }
    }
}
