//
//  ExchangeRatesViewModel.swift
//  ExchangeRatesNBP
//
//  Created by Yevhen Shevchenko on 04.02.2021.
//

import Foundation

protocol ChartsListViewModelProtocol: class {
    var nubmerOfRows: Int { get }
    var textForSection: String? { get }
    var searchBarIsActive: Bool { get set }
    var titleForNavigationBar: String { get }
    func fetchChartViewModel(indexPath: IndexPath) -> ChartViewModelProtocol?
    func filterForSearchText(_ searchText: String?, completion: () -> Void)
    func fetchRate(indexPath: IndexPath) -> RateViewCellViewModelProtocol?
    func fetchRates(completion: @escaping () -> Void)
}

class ChartsListViewModel: ChartsListViewModelProtocol {
    
    // MARK: Public properties
    
    var titleForNavigationBar: String {
        Constant.ControllerTitle.charts
    }
    
    var nubmerOfRows: Int {
        isFiltererd ? filteredRates.count : rates.count
    }
    
    var textForSection: String? {
        guard let date = currentDate else { return nil }
        return "KURSY ŚREDNIE - AKTUALE Z DNIA \(date)"
    }
    
    var searchBarText: String?
    var searchBarIsActive: Bool = false
    
    // MARK: Private properties
    
    private var currentDate: String?
    private var rates = [Rate]()
    private var filteredRates = [Rate]()
    
    private var searchBarIsEmpty: Bool {
        guard let text = searchBarText else { return false }
        return text.isEmpty
    }
    
    private var isFiltererd: Bool {
        searchBarIsActive && !searchBarIsEmpty
    }
    
    // MARK: Private methods
    
    func fetchChartViewModel(indexPath: IndexPath) -> ChartViewModelProtocol? {
        let rate = isFiltererd ? filteredRates[indexPath.row] : rates[indexPath.row]
        guard let code = rate.code else { return nil }
        return ChartViewModel(code: code)
    }
    
    func fetchRate(indexPath: IndexPath) -> RateViewCellViewModelProtocol? {
        let rate = isFiltererd ? filteredRates[indexPath.row] : rates[indexPath.row]
        return RateViewCellViewModel(rate: rate)
    }
    
    func fetchRates(completion: @escaping() -> Void) {
        let url = URLS.seriesOfLatestExchangeRates.rawValue

        NetworkManager.shared.fetchData(url) { (data: [Currencies]?) in
            
            if let data = data {
                self.currentDate = data.last?.effectiveDate
                self.rates = Rate.fetchListOfRatesWithPercentageСhanges(from: data)
                completion()
            } else {
                completion()
            }
        }
    }
    
    func filterForSearchText(_ searchText: String?, completion: () -> Void) {
        guard let searchText = searchText else { return }
        searchBarText = searchText
        filteredRates = rates.filter {
            $0.currency!.lowercased().contains(searchText.lowercased())
                || $0.code!.lowercased().contains(searchText.lowercased())
        }
        completion()
    }
}

