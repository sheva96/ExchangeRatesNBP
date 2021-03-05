//
//  ConverterViewController.swift
//  ExchangeRatesNBP
//
//  Created by Yevhen Shevchenko on 10.02.2021.
//

import UIKit


protocol ConverterViewControllerDelegate: class {
    func updateViewModel(_ viewModel: ConverterViewModel)
}

class ConverterViewController: UIViewController {
    
    private var converterViewModel: ConverterViewModelProtocol! {
        didSet {
            converterViewModel.topInfoViewModel.bind { [unowned self] in
                self.topInfoView.viewModel = $0
            }
            converterViewModel.bottomInfoViewModel.bind { [unowned self] in
                self.bottomInfoView.viewModel = $0
            }
            converterViewModel.title.bind { [unowned self] in
                self.navigationItem.title = $0
            }
        }
    }

    lazy private var topInfoView: InfoView = {
        let view = InfoView()
        view.tag = 0
        view.delegate = self
        return view
    }()
    
    lazy private var bottomInfoView: InfoView = {
        let view = InfoView()
        view.delegate = self
        view.tag = 1
        return view
    }()
    
    lazy private var keyPadView: KeyPadView = {
        let keyPadView = KeyPadView()
        keyPadView.delegate = self
        return keyPadView
    }()
    
    lazy private var reversButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "change")?.withTintColor(.gold)
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(converterViewModel,
                         action: #selector(ConverterViewModel.revers),
                         for: .touchUpInside)
        return button
    }()
    
    // MARK: Overriden methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .customeBlack
        
        converterViewModel = ConverterViewModel()
        
        setupNavigationBar()
        setupSubviews()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let xPoint = view.layoutMargins.left
        let yPoint = reversButton.center.y
        let width = view.bounds.width - reversButton.bounds.width - xPoint * 3
        let rect = CGRect(x: xPoint, y: yPoint, width: width, height: 2)
        
        view.addLine(rect: rect, color: .gold)
    }
    
    // MARK: - Actions
    
    @objc func updateButtonAction(_ sender: UIButton) {
        sender.rotateAnimation360()
        converterViewModel.updateData()
    }
    
    // MARK: - Private methods
    
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .customeBlack
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.customeLightGrey,
            .font: UIFont.systemFont(ofSize: 12, weight: .thin)
        ]
    
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.isTranslucent = false
        
        let image = UIImage(named: "redo")
        let updateButton = UIButton(type: .system)
        updateButton.setImage(image, for: .normal)
        updateButton.addTarget(self, action: #selector(updateButtonAction), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: updateButton)
    }
    
    private func setupSubviews() {
        view.addSubview(topInfoView)
        view.addSubview(reversButton)
        view.addSubview(bottomInfoView)
        view.addSubview(keyPadView)
        
        topInfoView.translatesAutoresizingMaskIntoConstraints = false
        reversButton.translatesAutoresizingMaskIntoConstraints = false
        bottomInfoView.translatesAutoresizingMaskIntoConstraints = false
        keyPadView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topInfoView.topAnchor.constraint(equalTo: view.topAnchor),
            topInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topInfoView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.15),
            
            reversButton.topAnchor.constraint(equalTo: topInfoView.bottomAnchor, constant: 8),
            reversButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            reversButton.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.1),
            
            bottomInfoView.topAnchor.constraint(equalTo: reversButton.bottomAnchor, constant: 8),
            bottomInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomInfoView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.15),
            
            keyPadView.topAnchor.constraint(equalTo: bottomInfoView.bottomAnchor),
            keyPadView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            keyPadView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            keyPadView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
        ])
    }
}

// MARK: - KeyPadViewDelegate

extension ConverterViewController: KeyPadViewDelegate {
    func didPressedButton(_ sender: UIButton) {
        converterViewModel.buttonTitle = sender.currentTitle
    }
}

// MARK: - InfoViewDelegate

extension ConverterViewController: InfoViewDelegate {
    func didTapped(_ view: InfoView) {
        converterViewModel.infoViewTag = view.tag
        
        let tableVC = CurrenciesListTableViewController()
        let navigationController = UINavigationController(rootViewController: tableVC)
        
        tableVC.viewModel = converterViewModel.viewModelForTable
        tableVC.delegate = self

        present(navigationController, animated: true)
    }
}

// MARK: - ConverterViewControllerDelegate

extension ConverterViewController: ConverterViewControllerDelegate {
    func updateViewModel(_ viewModel: ConverterViewModel) {
        converterViewModel.convertibleRates = viewModel.convertibleRates
    }
}
