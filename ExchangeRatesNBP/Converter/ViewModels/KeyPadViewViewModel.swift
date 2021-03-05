//
//  KeyPadViewViewModel.swift
//  ExchangeRatesNBP
//
//  Created by Yevhen Shevchenko on 03.03.2021.
//

import Foundation

protocol KeyPadViewViewModelProtocol {
    func didPressedButton(title: String?)
}

class KeyPadViewViewModel: KeyPadViewViewModelProtocol {
    
    func didPressedButton(title: String?) {
        let key = UserDefaultsManager.Key.switchSoundKey.rawValue
        
        guard UserDefaultsManager.shared.getValue(at: key) else { return }
        
        if title == "." {
            AudioManager.shared.play(AudioManager.SoundID.dot)
        } else if title == nil {
            AudioManager.shared.play(AudioManager.SoundID.remove)
        } else {
            AudioManager.shared.play(AudioManager.SoundID.tap)
        }
    }
}
