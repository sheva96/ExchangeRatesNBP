//
//  Rate.swift
//  ExchangeRatesNBP
//
//  Created by Yevhen Shevchenko on 07.02.2021.
//

import Foundation

struct Rate: Codable {
    let currency: String?
    let code: String?
    let mid: Double?
    let percentageСhange: Double?
    
    init(currency: String?, code: String?, mid: Double?, percentageСhange: Double? = nil) {
        self.currency = currency
        self.code = code
        self.mid = mid
        self.percentageСhange = percentageСhange
    }
}

// MARK: - Fetch list of rates with percentage changes

extension Rate {
    
    static func fetchListOfRatesWithPercentageСhanges(from data: [Currencies]) -> [Rate] {
        guard let oldRates = data.first?.rates,
              let currentRates = data.last?.rates else { return [] }

        var rates = [Rate]()
        
        zip(oldRates, currentRates).forEach {
            if $0.code == $1.code {
                
                guard let currentMid = $1.mid, let oldMid = $0.mid else { return }
                
                let percentageСhange = (currentMid / oldMid - 1) * 100
                
                let rate = Rate(currency: $1.currency,
                                code: $1.code,
                                mid: $1.mid,
                                percentageСhange: percentageСhange)
                
                rates.append(rate)
            }
        }
        return rates
    }
}

// MARK: - Fetch list of rates

extension Rate {
    
    static func fetchListOfRates(from data: [Currencies]) -> [Rate]? {
        guard var rates = data.first?.rates else { return nil }
        let plz = Rate(currency: "Zloty", code: Code.plz.rawValue.uppercased(), mid: 0)
        rates.insert(plz, at: 0)
        return rates
    }
}

// MARK: - Fetch start convertible rates

extension Rate {
    
    static func fetchConvertibleRates(from listOfRates: [Rate]?, with firstRate: Code, and secondRate: Code) -> [Rate] {
        guard let rates = listOfRates else { return [] }
        return rates.filter {
            $0.code == firstRate.rawValue.uppercased() || $0.code == secondRate.rawValue.uppercased()
        }
    }
}

// MARK: - Update convertible rates

extension Rate {
    
    static func update(old convertibleRates: [Rate]?, from listOfRates: [Rate]?) -> [Rate]? {
        guard let convertibleRates = convertibleRates,
              let listOfRates = listOfRates else { return nil }
        
        var rates = listOfRates.filter {
            $0.code == convertibleRates.first?.code || $0.code == convertibleRates.last?.code
        }
        
        if rates.first?.code == convertibleRates.first?.code {
            return rates
        } else {
            rates.reverse()
            return rates
        }
    }
}
