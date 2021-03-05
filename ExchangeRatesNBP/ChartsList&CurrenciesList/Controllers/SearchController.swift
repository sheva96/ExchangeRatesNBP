//
//  SearchController.swift
//  ExchangeRatesNBP
//
//  Created by Yevhen Shevchenko on 28.02.2021.
//

import UIKit

class SearchController: UISearchController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.searchTextField.textColor = .customeLightGrey
    }

    override init(searchResultsController: UIViewController?) {
        super.init(searchResultsController: searchResultsController)
        obscuresBackgroundDuringPresentation = false
        searchBar.tintColor = .gold
        searchBar.keyboardAppearance = .dark
        searchBar.searchTextField.leftView?.tintColor = .customeLightGrey
        searchBar.searchTextField.tintColor = .gold
        searchBar.setValue("Anuluj", forKey: "cancelButtonText")
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Shukaj", attributes: [.foregroundColor: UIColor.customeLightGrey]
        )
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
