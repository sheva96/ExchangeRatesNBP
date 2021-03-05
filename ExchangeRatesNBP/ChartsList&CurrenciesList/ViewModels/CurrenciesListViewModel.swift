//
//  ListTableViewModel.swift
//  ExchangeRatesNBP
//
//  Created by Yevhen Shevchenko on 15.02.2021.
//

import Foundation

protocol CurrenciesListViewModelProtocol: class {
    var listOfRates: [Rate] { get set }
    var convertibleRates: [Rate] { get set }
    var converterViewModel: ConverterViewModel { get }
    var nubmerOfRows: Int { get }
    var infoViewTag: Int { get }
    var titleForNavigationBar: String { get }
    var searchBarIsActive: Bool { get set }
    func filterForSearchText(_ searchText: String?, completion: () -> Void)
    func fetchRate(indexPath: IndexPath) -> RateViewCellViewModelProtocol?
    func updateConvertibleRates(indexPath: IndexPath)
    init(listOfRates: [Rate], convertibleRates: [Rate], infoViewTag: Int)
}

class CurrenciesListViewModel: CurrenciesListViewModelProtocol {
    
    // MARK: - Public properties
    
    var listOfRates: [Rate]
    var convertibleRates: [Rate]
    var infoViewTag: Int
    
    var searchBarText: String?
    var searchBarIsActive: Bool = false
    
    var titleForNavigationBar: String = Constant.ControllerTitle.currencies
    
    var nubmerOfRows: Int {
        isFiltererd ? filteredListOfRates.count : listOfRates.count
    }
    
    var converterViewModel: ConverterViewModel {
        ConverterViewModel(convertibleRates: convertibleRates)
    }
    
    // MARK: - Private properties
    
    private var filteredListOfRates = [Rate]()
    
    private var searchBarIsEmpty: Bool {
        guard let text = searchBarText else { return false }
        return text.isEmpty
    }
    
    private var isFiltererd: Bool {
        searchBarIsActive && !searchBarIsEmpty
    }
    
    // MARK: - Init
    
    required init(listOfRates: [Rate], convertibleRates: [Rate], infoViewTag: Int) {
        self.listOfRates = listOfRates
        self.convertibleRates = convertibleRates
        self.infoViewTag = infoViewTag
    }
    
    // MARK: - Public methods
    
    func filterForSearchText(_ searchText: String?, completion: () -> Void) {
        guard let searchText = searchText else { return }
        searchBarText = searchText
        
        filteredListOfRates = listOfRates.filter {
            $0.currency!.lowercased().contains(searchText.lowercased()) ||
                $0.code!.lowercased().contains(searchText.lowercased())
        }
        completion()
    }
    
    func fetchRate(indexPath: IndexPath) -> RateViewCellViewModelProtocol? {
        let rate = isFiltererd ? filteredListOfRates[indexPath.row] : listOfRates[indexPath.row]
        return RateViewCellViewModel(rate: rate)
    }
    
    func updateConvertibleRates(indexPath: IndexPath) {
        let rate = isFiltererd ? filteredListOfRates[indexPath.row] : listOfRates[indexPath.row]
        
        if infoViewTag == 0 {
            convertibleRates[infoViewTag] = rate
        } else {
            convertibleRates[infoViewTag] = rate
        }
    }
}
