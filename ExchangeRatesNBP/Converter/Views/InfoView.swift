//
//  ContentView.swift
//  ExchangeRatesNBP
//
//  Created by Yevhen Shevchenko on 11.02.2021.
//

import UIKit

protocol InfoViewDelegate: class {
    func didTapped(_ view: InfoView)
}

class InfoView: UIView {
    
    // MARK: Properties
    
    var viewModel: InfoViewViewModelProtocol? {
        didSet {
            сodeLabel.text = viewModel?.code
            valueLabel.text = viewModel?.value
            
            guard let code = viewModel?.code else { return }
            imageView.image = UIImage(named: code)
        }
    }
    
    weak var delegate: InfoViewDelegate!
    
    let imageView = UIImageView()
    
    lazy private var сodeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .customeLightGrey
        label.font = .boldSystemFont(ofSize: 17)
        return label
    }()
    
    lazy private var valueLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = .systemFont(ofSize: UIScreen.main.bounds.width * 0.10, weight: .regular)
        label.textAlignment = .right
        label.textColor = .gold
        label.baselineAdjustment = .alignCenters
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    // MARK: Overriden init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let longPress = UILongPressGestureRecognizer(target: self, action:  #selector(longPressAction(_:)))
        longPress.minimumPressDuration = 0
        addGestureRecognizer(longPress)

        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc private func longPressAction(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            backgroundColor = UIColor.gold.withAlphaComponent(0.2)
        } else if gesture.state == .ended {
            backgroundColor = .clear
            delegate.didTapped(self)
        }
    }

    // MARK: - Private methods
    
    private func setupSubviews() {
        
        addSubview(imageView)
        addSubview(сodeLabel)
        addSubview(valueLabel)
        
        сodeLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: layoutMargins.left),
            imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            
            сodeLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            сodeLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
            
            valueLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            valueLabel.leadingAnchor.constraint(equalTo: сodeLabel.trailingAnchor, constant: 8),
            valueLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, constant: -layoutMargins.left),
        ])
    }
}
