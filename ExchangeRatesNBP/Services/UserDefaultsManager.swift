//
//  UserDefaultsManager.swift
//  CurrencyConverter
//
//  Created by Yevhen Shevchenko on 24.02.2021.
//

import Foundation

class UserDefaultsManager {

    enum Key: String {
        case switchSoundKey
        case listOfRates
    }

    static let shared = UserDefaultsManager()
    
    private let userDefautls = UserDefaults.standard
    
    private init() {}
    
    func save(value: Bool, at key: String) {
        userDefautls.set(value, forKey: key)
    }
    
    func getValue(at key: String) -> Bool {
        userDefautls.bool(forKey: key)
    }
    
    func saveConvertibleRatesList(data: [Currencies]) {
        guard let data = try? JSONEncoder().encode(data) else { return }
        let key = UserDefaultsManager.Key.listOfRates.rawValue
        userDefautls.set(data, forKey: key)
    }
    
    func fetchConvertibleRatesList() -> [Currencies] {
        let key = UserDefaultsManager.Key.listOfRates.rawValue
        guard let data = userDefautls.object(forKey: key) as? Data else { return [] }
        guard let newData = try? JSONDecoder().decode([Currencies].self, from: data) else { return [] }
        return newData
    }
}
