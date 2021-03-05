//
//  ExchangeRateTableViewCellViewModel.swift
//  ExchangeRatesNBP
//
//  Created by Yevhen Shevchenko on 04.02.2021.
//

import Foundation

protocol RateViewCellViewModelProtocol {
    var imageName: String { get }
    var code: String { get }
    var currency: String { get }
    var mid: String { get }
    var percentageСhange: String? { get }
    init(rate: Rate)
}

class RateViewCellViewModel: RateViewCellViewModelProtocol {
    
    var imageName: String {
        rate.code ?? ""
    }
    
    var code: String {
        fetchCode(from: rate)
    }
    
    var currency: String {
        rate.currency ?? ""
    }
    
    var mid: String {
         fetchMid(from: rate)
    }
    
    var percentageСhange: String? {
        guard let value = rate.percentageСhange else { return nil }
        return fetchPercentageСhange(from: value)
    }
    
    private let rate: Rate
    
    required init(rate: Rate) {
        self.rate = rate
    }
    
    // MARK: - Private methods
    
    private func fetchCode(from rate: Rate) -> String {
        guard let rateCode = rate.code,
              let code = Code(rawValue: rateCode.lowercased()) else { return "" }

        switch code {
        case .huf, .jpy, .isk, .clp, .inr, .krw:
            return "100 \(code)"
        case .idr:
            return "1000 \(code)"
        default:
            return "1 \(rateCode)"
        }
    }
    
    private func fetchMid(from rate: Rate) -> String {
        guard let mid = rate.mid else { return "" }
        guard let code = Code(rawValue: rate.code?.lowercased() ?? "") else { return "" }
        
        switch code {
        case .huf, .jpy, .isk, .clp, .inr, .krw:
            return String(format: "%.4f", mid * 100)
        case .idr:
            return String(format: "%.4f", mid * 1000)
        default:
            return String(format: "%.4f", mid)
        }
    }
    
    private func fetchPercentageСhange(from value: Double) -> String {
        let stringValue = String(format: "%.2f", value)
        
        if value < 0 {
            return "▼ \(stringValue.dropFirst())%"
        } else if value > 0 {
            return "▲ \(stringValue)%"
        } else {
            return "\(stringValue)%"
        }
    }
}
