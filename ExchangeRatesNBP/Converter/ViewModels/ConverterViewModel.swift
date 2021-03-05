//
//  ConverterViewModel.swift
//  ExchangeRatesNBP
//
//  Created by Yevhen Shevchenko on 11.02.2021.
//

import Foundation

protocol ConverterViewModelProtocol {
    var convertibleRates: [Rate]? { get set }
    var listOfRates: [Rate]? { get }
    var buttonTitle: String? { get set }
    var infoViewTag: Int? { get set }
    var title: Box<String?> { get set }
    var topInfoViewModel: Box<InfoViewViewModelProtocol?> { get }
    var bottomInfoViewModel: Box<InfoViewViewModelProtocol?> { get }
    var viewModelForTable: CurrenciesListViewModelProtocol { get }
    func updateData()
    func revers()
}

class ConverterViewModel: ConverterViewModelProtocol {
    
    // MARK: - Public properties
    
    var title: Box<String?> = Box(value: nil)
    var infoViewTag: Int?
    var listOfRates: [Rate]?
    
    var convertibleRates: [Rate]? {
        didSet {
            updateValues()
        }
    }
    
    var topInfoViewModel: Box<InfoViewViewModelProtocol?> = Box(value: nil)
    var bottomInfoViewModel: Box<InfoViewViewModelProtocol?> = Box(value: nil)
    
    var viewModelForTable: CurrenciesListViewModelProtocol {
        CurrenciesListViewModel(listOfRates: listOfRates ?? [],
                                   convertibleRates: convertibleRates ?? [],
                                   infoViewTag: infoViewTag!)
    }
    
    var buttonTitle: String? {
        willSet {
            changeInputText(value: newValue)
        }
        didSet {
            updateValues()
        }
    }
    
    // MARK: - Private properties
    
    private var data: [Currencies]? {
        didSet {
            guard let data = data else { return }
            
            listOfRates = Rate.fetchListOfRates(from: data)
            title.value = "Aktualne kursy z dnia \(data.first?.effectiveDate ?? "")"
            
            if convertibleRates == nil {
                convertibleRates = Rate.fetchConvertibleRates(from: listOfRates, with: .plz, and: .eur)
            } else {
                convertibleRates = Rate.update(old: convertibleRates, from: listOfRates)
            }
        }
    }
    
    private var inputText: String = "0" {
        didSet {
            if inputText.count > 15 {
                inputText.removeLast()
            }
        }
    }
    
    private var outputText: String {
        let value = Double(inputText) ?? 0
        var result = 0.0

        guard let firtsCode = convertibleRates?.first?.code,
              let secondCode = convertibleRates?.last?.code,
              let firstRateMid = convertibleRates?.first?.mid,
              let secondRateMid = convertibleRates?.last?.mid,
              let newFirstCode = Code(rawValue: firtsCode.lowercased()),
              let newSecondCode = Code(rawValue: secondCode.lowercased()) else { return "0" }
        
        if newFirstCode == .plz, newSecondCode == .plz {
            result = value
        } else if newFirstCode == .plz {
            result = value / secondRateMid
        } else if newSecondCode == .plz {
            result = value * firstRateMid
        } else {
            result = value * firstRateMid / secondRateMid
        }
        
        return String.convertNumberFormatter(result) ?? "0"
    }
    
    // MARK: - Init
    
    init() {
        updateData()
    }
    
    init(convertibleRates: [Rate]) {
        self.convertibleRates = convertibleRates
    }
    
    // MARK: - Actions
    
    @objc func revers() {
        convertibleRates?.reverse()
    }
    
    // MARK: - Public methods
    
    func updateData() {
        let userDefaultsManager = UserDefaultsManager.shared
        let networkManager = NetworkManager.shared
        let url = URLS.currentRates.rawValue
        
        networkManager.fetchData(url) { [weak self] (data: [Currencies]?) in
            
            if let data = data {
                self?.data = data
                userDefaultsManager.saveConvertibleRatesList(data: data)
            } else if !userDefaultsManager.fetchConvertibleRatesList().isEmpty {
                self?.data = userDefaultsManager.fetchConvertibleRatesList()
            }
        }
    }
    
    // MARK: - Private methods
    
    private func updateValues() {
        topInfoViewModel.value = InfoViewViewModel(
            code: convertibleRates?.first?.code ?? "", value: inputText
        )
        bottomInfoViewModel.value = InfoViewViewModel(
            code: convertibleRates?.last?.code ?? "", value: outputText)
    }
    
    private func changeInputText(value: String?) {
        if value == ".", inputText.contains(value!) {
            return
        } else if value == nil, inputText.count > 1 {
            inputText.removeLast()
        } else if value == nil {
            inputText = "0"
        } else if value == ".", inputText == "0"  {
            inputText += value!
        } else if value != nil, inputText == "0"  {
            inputText = value!
        } else if value != nil {
            inputText += value!
        }
    }
}
