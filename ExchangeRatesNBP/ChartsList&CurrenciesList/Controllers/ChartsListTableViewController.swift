//
//  ExchangeRatesTableViewController.swift
//  ExchangeRatesNBP
//
//  Created by Yevhen Shevchenko on 04.02.2021.
//

import UIKit

class ChartsListTableViewController: UITableViewController {
    
    // MARK: Private properties
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .large)
        ai.color = .customeLightGrey
        ai.hidesWhenStopped = true
        return ai
    }()
    
    private lazy var searchController: SearchController = {
        let sc = SearchController(searchResultsController: nil)
        sc.searchResultsUpdater = self
        return sc
    }()
    
    private lazy var refrechControll: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.tintColor = .customeLightGrey
        rc.addTarget(self, action: #selector(refrechControllAction), for: .valueChanged)
        return rc
    }()

    private var viewModel: ChartsListViewModelProtocol! {
        didSet {
            viewModel.fetchRates {
                self.activityIndicatorView.stopAnimating()
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: Overriden methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = ChartsListViewModel()
        title = viewModel.titleForNavigationBar
        
        setupSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    // MARK: Actions
    
    @objc private func refrechControllAction() {
        self.viewModel.fetchRates { [unowned self] in
            self.tableView.reloadData()
            self.refrechControll.endRefreshing()
        }
        activityIndicatorView.stopAnimating()
    }
    
    // MARK: Private methods
    
    private func setupSubviews() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        activityIndicatorView.startAnimating()
        
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.rowHeight = 100
        tableView.indicatorStyle = .white
        tableView.separatorStyle = .none
        tableView.backgroundColor = .customeBlack
        tableView.refreshControl = refrechControll
        tableView.backgroundView = activityIndicatorView
        tableView.register(RateTableViewCell.self, forCellReuseIdentifier: RateTableViewCell.id)
    }
}

// MARK: - TableViewDataSource

extension ChartsListTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.nubmerOfRows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RateTableViewCell.id, for: indexPath) as! RateTableViewCell
        cell.viewModel = viewModel.fetchRate(indexPath: indexPath)
        return cell
    }
}

// MARK: - TableViewDelegate

extension ChartsListTableViewController {
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = TableViewHeaderView()
        headerView.title.text = viewModel.textForSection
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        nil
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        34
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        0
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let chartVC = ChartViewController()
        chartVC.chartViewModel = viewModel.fetchChartViewModel(indexPath: indexPath)
        navigationController?.pushViewController(chartVC, animated: true)
    }
}

// MARK: - SearchResultsUpdating

extension ChartsListTableViewController: UISearchResultsUpdating  {
    
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.searchBarIsActive = searchController.isActive
        viewModel.filterForSearchText(searchController.searchBar.text) {
            self.tableView.reloadData()
        }
    }
}
