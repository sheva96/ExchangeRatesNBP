//
//  SettingsViewController.swift
//  ExchangeRatesNBP
//
//  Created by Yevhen Shevchenko on 23.02.2021.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var settingViewModel: SettingsViewModelProtocol!
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let rowHeight: CGFloat = 50
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingViewModel = SettingsViewModel()
        
        title = settingViewModel.navigationTitle
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupTableView()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        view.backgroundColor = .customeBlack
        
        tableView.dataSource = self
        tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.id)
        tableView.isScrollEnabled = false
        tableView.rowHeight = rowHeight
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .gold
        tableView.layer.borderWidth = 0.5
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = rowHeight * CGFloat(settingViewModel.nubmerOfRows) * 0.2
        tableView.layer.cornerCurve = .continuous
        tableView.layer.borderColor = UIColor.gold.cgColor
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: view.layoutMargins.left),
            tableView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: rowHeight * CGFloat(settingViewModel.nubmerOfRows)),
        ])
    }
 
}

// MARK: - TableViewDataSource

extension SettingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        settingViewModel.nubmerOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SettingTableViewCell(style: .value1, reuseIdentifier: SettingTableViewCell.id)
        cell.viewModel = settingViewModel.fetchCell(indexPath: indexPath)
        return cell
    }
}
