//
//  SettingsViewModel.swift
//  ExchangeRatesNBP
//
//  Created by Yevhen Shevchenko on 23.02.2021.
//

import Foundation

protocol SettingsViewModelProtocol: class {
    var navigationTitle: String { get }
    var nubmerOfRows: Int { get }
    func fetchCell(indexPath: IndexPath) -> SettingViewCellViewModelProtocol?
}

class SettingsViewModel: SettingsViewModelProtocol {
    
    var navigationTitle = Constant.ControllerTitle.settings
    
    let titles = ["Dźwięk", "Wersja"]
    
    func fetchCell(indexPath: IndexPath) -> SettingViewCellViewModelProtocol? {
        let title = titles[indexPath.row]
        let secondaryTitle = indexPath.row == 1 ? "1.0.0" : nil
        return SettingViewCellViewModel(title: title, secondaryTitle: secondaryTitle, cellIndexPath: indexPath)
    }
    
    var nubmerOfRows: Int {
        titles.count
    }
}

