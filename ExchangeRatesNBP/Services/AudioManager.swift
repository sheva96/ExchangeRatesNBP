//
//  AudioManager.swift
//  CurrencyConverter
//
//  Created by Yevhen Shevchenko on 23.02.2021.
//

import Foundation
import AVFoundation

class AudioManager {

    static let shared = AudioManager()
    
    private init() {}

    func play(_ id: AudioManager.SoundID) {
        AudioServicesPlaySystemSound(id.rawValue)
    }
    
    enum SoundID: UInt32 {
        case tap = 1104
        case remove = 1155
        case dot = 1156
    }
}

