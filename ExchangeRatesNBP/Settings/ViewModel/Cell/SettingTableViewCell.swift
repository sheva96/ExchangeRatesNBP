//
//  SettingTableViewCell.swift
//  ExchangeRatesNBP
//
//  Created by Yevhen Shevchenko on 23.02.2021.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
    
    static let id = "cell"
    
    private lazy var switchView: UISwitch = {
        let switchView = UISwitch()
        switchView.isOn = viewModel.switchValue
        switchView.onTintColor = .gold
        switchView.thumbTintColor = .darkGray
        switchView.tintColor = .blue
        switchView.addTarget(self, action: #selector(switchAction(_:)), for: .valueChanged)
        return switchView
    }()
    
    var viewModel: SettingViewCellViewModelProtocol! {
        didSet {
            selectionStyle = .none
            backgroundColor = .customeDarkGray
            
            let speakerImage = UIImage(systemName: "speaker.zzz")?.withTintColor(.gold, renderingMode: .alwaysOriginal)
            let versionImage = UIImage(systemName: "number")?.withTintColor(.gold, renderingMode: .alwaysOriginal)
            
            if #available(iOS 14.0, *) {
                var content = defaultContentConfiguration()
                content.text = viewModel.title
                content.textProperties.color = .customeLightGrey
                content.secondaryTextProperties.color = .gold
                
                if viewModel.cellIndexPath.row == 0 {
                    content.image = speakerImage
                    accessoryView = switchView
                } else {
                    content.image = versionImage
                    content.secondaryText = viewModel.secondaryTitle
                }
                contentConfiguration = content
            } else {
                textLabel?.text = viewModel.title
                textLabel?.textColor = .customeLightGrey
                detailTextLabel?.textColor = .gold
                
                if viewModel.cellIndexPath.row == 0 {
                    imageView?.image = speakerImage
                    accessoryView = switchView
                } else {
                    imageView?.image = versionImage
                    detailTextLabel?.text = viewModel.secondaryTitle
                }
            }
        }
    }
    
    @objc private func switchAction(_ sender: UISwitch) {
        viewModel.switchValue = sender.isOn ? true : false
    }
}
