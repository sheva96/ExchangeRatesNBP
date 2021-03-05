//
//  Extension + UIView.swift
//  ExchangeRatesNBP
//
//  Created by Yevhen Shevchenko on 16.02.2021.
//

import UIKit

extension UIView {
    
    func addLine(rect: CGRect, color: UIColor) {
        let line = UIView(frame: rect)
        line.backgroundColor = color
        line.layer.cornerRadius = rect.height / 2
        
        addSubview(line)
    }

    func rotateAnimation360() {
        UIView.animate(withDuration: 0.5) {
          self.transform = CGAffineTransform(rotationAngle: .pi)
          self.transform = CGAffineTransform(rotationAngle: .pi * 2)
         }
    }
}


