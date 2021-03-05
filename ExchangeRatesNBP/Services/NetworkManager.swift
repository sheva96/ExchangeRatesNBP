//
//  NetworkManager.swift
//  ExchangeRatesNBP
//
//  Created by Yevhen Shevchenko on 04.03.2021.
//

import Foundation

enum URLS: String {
    case currentRates = "https://api.nbp.pl/api/exchangerates/tables/a/?format=json"
    case seriesOfLatestExchangeRates = "https://api.nbp.pl/api/exchangerates/tables/a/last/2/?format=json"
    
    static func fetchRateOfCurrency(at code: String) -> String {
        "https://api.nbp.pl/api/exchangerates/rates/a/\(code)/last/90/?format=json"
    }
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchData<T: Decodable>(_ url: String, completionHandler: @escaping (T?) -> Void) {
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard error == nil else  {
                DispatchQueue.main.async {
                    completionHandler(nil)
                }
                return
            }
            
            guard let data = data else { return }
            
            do {
                let currency = try JSONDecoder().decode(T.self, from: data)
                
                DispatchQueue.main.async {
                    completionHandler(currency)
                }
            } catch let error {
                print(error)
            }
        }.resume()
    }
}
