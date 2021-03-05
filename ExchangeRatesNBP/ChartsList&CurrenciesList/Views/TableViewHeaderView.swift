//
//  HeaderViewForSection.swift
//  ExchangeRatesNBP
//
//  Created by Yevhen Shevchenko on 12.02.2021.
//

import UIKit

class TableViewHeaderView: UITableViewHeaderFooterView {

    lazy var title: UILabel = {
        let title = UILabel()
        title.textColor = .customeSecondLightGrey
        title.font = .systemFont(ofSize: 17, weight: .thin)
        title.numberOfLines = 1
        title.adjustsFontSizeToFitWidth = true
        title.minimumScaleFactor = 0.5
        return title
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setSubview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSubview() {
        contentView.backgroundColor = .customeBlack
        contentView.addSubview(title)
        
        title.translatesAutoresizingMaskIntoConstraints = false
    
        NSLayoutConstraint.activate([
            title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            title.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            title.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor)
        ])
    }
}
