//
//  ChartViewController.swift
//  ExchangeRatesNBP
//
//  Created by Yevhen Shevchenko on 17.02.2021.
//

import UIKit
import Charts

class ChartViewController: UIViewController {
    
    var chartViewModel: ChartViewModelProtocol! {
        didSet {
            chartViewModel.dates.bind { [unowned self] in
                for chart in self.charts {
                    chart.dates = $0
                    chart.xAxis.valueFormatter = IndexAxisValueFormatter(values: $0)
                }
            }
            chartViewModel.data.bind { [unowned self] (chartData) in
                for (data, chart) in zip(chartData, self.charts) {
                    chart.data = data
                }
            }
        }
    }

    // MARK: Private properties
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let margin: CGFloat = 5
    private let charts = [CustomeLineChartView(), CustomeLineChartView(), CustomeLineChartView()]
    
    private lazy var segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: chartViewModel.items)
        sc.selectedSegmentTintColor = .gold
        sc.tintColor = .customeDarkGray
        sc.selectedSegmentIndex = chartViewModel.items.startIndex
        sc.setTitleTextAttributes([.foregroundColor: UIColor.customeLightGrey], for: .normal)
        sc.setTitleTextAttributes([.foregroundColor: UIColor.customeBlack], for: .selected)
        sc.addTarget(self, action: #selector(segmentedControlAction(_:)), for: .valueChanged)
        return sc
    }()
    
    // MARK: Overriden methods
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
    }
    
    // MARK: Actions
    
    @objc private func segmentedControlAction(_ sender: UISegmentedControl) {
        let startPoint = view.bounds.width
        
        switch sender.selectedSegmentIndex {
        case 0:
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        case 1:
            scrollView.setContentOffset(CGPoint(x: startPoint, y: 0), animated: true)
        case 2:
            scrollView.setContentOffset(CGPoint(x: startPoint * 2, y: 0), animated: true)
        default:
            break
        }
    }
    
    // MARK: Private methods
    
    private func setupSubview() {
        scrollView.isScrollEnabled = false
        view.backgroundColor = .customeBlack
        navigationItem.titleView = segmentedControl
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: margin * 2),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -margin * 2),
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])

        var startPoint = contentView.leadingAnchor

        charts.forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.backgroundColor = .customeBlack
            
            NSLayoutConstraint.activate([
                $0.leadingAnchor.constraint(equalTo: startPoint),
                $0.topAnchor.constraint(equalTo: contentView.topAnchor),
                $0.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                $0.widthAnchor.constraint(equalToConstant: view.bounds.width)
            ])
            startPoint = $0.trailingAnchor
        }
        contentView.trailingAnchor.constraint(equalTo: startPoint, constant: margin).isActive = true
    }
}
