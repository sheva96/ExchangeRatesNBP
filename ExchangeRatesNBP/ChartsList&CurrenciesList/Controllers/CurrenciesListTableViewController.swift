//
//  CurrenciesListTableViewController.swift
//  ExchangeRatesNBP
//
//  Created by Yevhen Shevchenko on 15.02.2021.
//

import UIKit

class CurrenciesListTableViewController: UITableViewController {
    
    var viewModel: CurrenciesListViewModelProtocol!
    weak var delegate: ConverterViewControllerDelegate!
    
    private lazy var searchController: SearchController = {
        let sc = SearchController(searchResultsController: nil)
        sc.searchResultsUpdater = self
        return sc
    }()
    
    // MARK: Overriden methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.rowHeight = 100
        tableView.indicatorStyle = .white
        tableView.separatorStyle = .none
        tableView.backgroundColor = .customeBlack
        tableView.register(RateTableViewCell.self, forCellReuseIdentifier: RateTableViewCell.id)
        
        navigationItem.title = viewModel.titleForNavigationBar
        navigationItem.searchController = searchController
        navigationItem.searchController?.hidesNavigationBarDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        searchController.dismiss(animated: false)
    }
}

// MARK: - TableViewDataSource

extension CurrenciesListTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.nubmerOfRows
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RateTableViewCell.id, for: indexPath) as! RateTableViewCell
        cell.viewModel = viewModel.fetchRate(indexPath: indexPath)
        cell.chevronImageView.isHidden = true
        cell.midLabel.isHidden = true

        return cell
    }
}

// MARK: - TableViewDelegate

extension CurrenciesListTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.updateConvertibleRates(indexPath: indexPath)
        delegate.updateViewModel(viewModel.converterViewModel)
        presentingViewController?.dismiss(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        UIView()
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        nil
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        tableView.layoutMargins.left
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        0
    }
}

// MARK: - SearchResultsUpdating

extension CurrenciesListTableViewController: UISearchResultsUpdating  {
    
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.searchBarIsActive = searchController.isActive
        viewModel.filterForSearchText(searchController.searchBar.text) {
            self.tableView.reloadData()
        }
    }
}
