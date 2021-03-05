//
//  NumPadView.swift
//  ExchangeRatesNBP
//
//  Created by Yevhen Shevchenko on 10.02.2021.
//

import UIKit

protocol KeyPadViewDelegate: class {
    func didPressedButton(_ sender: UIButton)
}

class KeyPadView: UIView {
    
    weak var delegate: KeyPadViewDelegate!
    
    private let viewModel = KeyPadViewViewModel()
    
    private let fontSize = UIScreen.main.bounds.width * 0.1
    
    // MARK: Ovveriden methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtonsStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Actions
    
    @objc private func buttonAction(_ sender: UIButton) {
        delegate.didPressedButton(sender)
        viewModel.didPressedButton(title: sender.currentTitle)
    }
    
    // MARK: Private methods
    
    private func setupButtonsStackView() {
        let stackView = UIStackView(arrangedSubviews: [
            getButtonsStackView(with: KeyPad.fetchTitles(from: .top)),
            getButtonsStackView(with: KeyPad.fetchTitles(from: .centerTop)),
            getButtonsStackView(with: KeyPad.fetchTitles(from: .centerBottom)),
            getButtonsStackView(with: KeyPad.fetchTitles(from: .bottom))
        ])
    
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 0
        
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func getButtonsStackView(with titles: [KeyPad]) -> UIStackView {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        
        titles.forEach {
            let button = UIButton(type: .system)
            button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
            
            if $0 == .del {
                let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: fontSize, weight: .thin)
                
                let image = UIImage(systemName: "delete.left")?.withTintColor(.gold, renderingMode: .alwaysOriginal)
                button.setImage(image, for: .normal)
                button.setPreferredSymbolConfiguration(symbolConfiguration, forImageIn: .normal)
                
                stackView.addArrangedSubview(button)
            } else {
                button.setTitleColor(.gold, for: .normal)
                button.setTitle($0.rawValue, for: .normal)
                button.titleLabel?.font = .systemFont(ofSize: fontSize, weight: .thin)
                
                stackView.addArrangedSubview(button)
            }
        }
        return stackView
    }
}
