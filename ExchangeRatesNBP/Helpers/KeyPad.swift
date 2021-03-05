//
//  NumPad.swift
//  CurrencyConverter
//
//  Created by Yevhen Shevchenko on 10.02.2021.
//

import Foundation

enum KeyPad: String {
    case dot = "."
    case del = ""
    case zero = "0"
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    
    enum Line {
        case top
        case centerTop
        case centerBottom
        case bottom
    }
    
    static func fetchTitles(from line: Line) -> [KeyPad] {
        switch line {
        case .top:
            return [.seven, .eight, .nine]
        case .centerTop:
            return [.four, .five, .six]
        case .centerBottom:
            return [.one, .two, .three]
        case .bottom:
            return [.del, .zero, .dot]
        }
    }
}
