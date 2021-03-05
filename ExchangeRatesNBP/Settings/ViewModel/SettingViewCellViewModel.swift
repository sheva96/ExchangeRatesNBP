//
//  SettingViewCellViewModel.swift
//  ExchangeRatesNBP
//
//  Created by Yevhen Shevchenko on 23.02.2021.
//

import Foundation

protocol SettingViewCellViewModelProtocol {
    var title: String { get }
    var secondaryTitle: String? { get }
    var cellIndexPath: IndexPath { get }
    var switchValue: Bool { get set }
    init(title: String, secondaryTitle: String?, cellIndexPath: IndexPath)
}

class SettingViewCellViewModel: SettingViewCellViewModelProtocol {
    
    private let key = UserDefaultsManager.Key.switchSoundKey.rawValue
    
    var switchValue: Bool {
        get {
            UserDefaultsManager.shared.getValue(at: key)
        }
        set {
            UserDefaultsManager.shared.save(value: newValue, at: key)
        }
    }
    
    var cellIndexPath: IndexPath
    var title: String
    var secondaryTitle: String?
    
    required init(title: String, secondaryTitle: String?, cellIndexPath: IndexPath) {
        self.title = title
        self.secondaryTitle = secondaryTitle
        self.cellIndexPath = cellIndexPath
    }
}
