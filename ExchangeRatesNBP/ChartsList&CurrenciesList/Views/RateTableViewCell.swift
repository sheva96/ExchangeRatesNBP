//
//  ExchangeRateTableViewCell.swift
//  ExchangeRatesNBP
//
//  Created by Yevhen Shevchenko on 04.02.2021.
//

import UIKit

class RateTableViewCell: UITableViewCell {

    static let id = "id"
    
    var viewModel: RateViewCellViewModelProtocol! {
        didSet {
            flagImageView.image = UIImage(named: viewModel.imageName)
            codeLabel.text = viewModel.code
            currencyLabel.text = viewModel.currency
            midLabel.text = viewModel.mid
            percentageСhangeLabel.text = viewModel.percentageСhange
            configurePercentageСhangeLabel()
        }
    }
    
    let flagImageView = UIImageView()
    
    lazy var chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")?
            .withTintColor(.gold, renderingMode: .alwaysOriginal)
        return imageView
    }()
    
    lazy var codeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .customeLightGrey
        label.font = .systemFont(ofSize: 17)
        return label
    }()
    
    lazy var currencyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gold
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    lazy var midLabel: UILabel = {
        let label = UILabel()
        label.textColor = .customeLightGrey
        label.font = .systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    lazy var percentageСhangeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var labelsStackView: UIStackView = {
        let leftStackView = createStackView(from: [codeLabel, currencyLabel], .fill)
        let rightStackView = createStackView(from: [midLabel, percentageСhangeLabel], .trailing)
        
        let stackView = UIStackView(arrangedSubviews: [leftStackView, rightStackView])
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()
    
    // MARK: Ovveriden methods

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectedBackgroundView = UIView()
        setSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureContentView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private methods
    
    private func setSubviews() {
        backgroundColor = .customeBlack
        constraints()
    }
    
    private func createStackView(from labels: [UILabel], _ alignment: UIStackView.Alignment) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [labels.first!, labels.last!])
        stackView.axis = .vertical
        stackView.alignment = alignment
        stackView.distribution = .fill
        stackView.spacing = 4
        return stackView
    }
    
    private func configureContentView() {
        let margin = layoutMargins.right
        let edgeInsets = UIEdgeInsets(top: 0, left: margin, bottom: margin / 2, right: margin)
        
        contentView.frame = contentView.frame.inset(by: edgeInsets)
        contentView.layer.cornerCurve = .continuous
        contentView.layer.cornerRadius =  20
        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = UIColor.gold.cgColor
        
        if isSelected {
            contentView.backgroundColor = UIColor.gold.withAlphaComponent(0.2)
        } else if isHighlighted {
            contentView.backgroundColor = UIColor.gold.withAlphaComponent(0.2)
        } else {
            contentView.backgroundColor = .customeDarkGray
        }
    }
    
    private func configurePercentageСhangeLabel() {
        switch percentageСhangeLabel.text?.first {
        case "▼":
            percentageСhangeLabel.textColor = .systemRed
        case "▲":
            percentageСhangeLabel.textColor = .systemGreen
        default:
            percentageСhangeLabel.textColor = .customeLightGrey
        }
    }
    
    private func constraints() {
        
        contentView.addSubview(flagImageView)
        contentView.addSubview(labelsStackView)
        contentView.addSubview(chevronImageView)
        
        flagImageView.translatesAutoresizingMaskIntoConstraints = false
        labelsStackView.translatesAutoresizingMaskIntoConstraints = false
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            flagImageView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            flagImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            flagImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.6),
            flagImageView.widthAnchor.constraint(equalTo: flagImageView.heightAnchor),
            
            labelsStackView.leadingAnchor.constraint(equalTo: flagImageView.trailingAnchor, constant: 8),
            labelsStackView.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -8),
            labelsStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            chevronImageView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            chevronImageView.centerYAnchor.constraint(equalTo: labelsStackView.centerYAnchor)
        ])
    }
}
