//
//  BalonMarker.swift
//  ExchangeRatesNBP
//
//  Created by Yevhen Shevchenko on 28.02.2021.
//

import UIKit
import Charts

class BalloonMarkerView: MarkerImage {
    
    var data = [String]()
    
    var color = UIColor.customeDarkGray
    var font = UIFont.systemFont(ofSize: 12)
    var textColor = UIColor.customeLightGrey
    var insets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    var minimumSize = CGSize()

    var label: String?
    var labelSize: CGSize = CGSize()
    var paragraphStyle: NSMutableParagraphStyle?
    var drawAttributes = [NSAttributedString.Key : Any]()
    
    init(data: [String]) {
        self.data = data
        paragraphStyle = NSParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle
        paragraphStyle?.alignment = .center
        super.init()
    }
    
    override func offsetForDrawing(atPoint point: CGPoint) -> CGPoint {
        var offset = self.offset

        let width = size.width
        let height = size.height
        let padding: CGFloat = 8.0

        var origin = point
        origin.x -= width / 2
        origin.y -= height

        let inset = (UIScreen.main.bounds.width * 0.05) + width
        let xMax = UIScreen.main.bounds.width - inset
        
        if origin.x + offset.x < 0.0 {
            offset.x = -origin.x + padding
        } else if origin.x + offset.x > xMax {
            offset.x = -width / 2 + padding
        }
        
        offset.y += -padding
        return offset
    }
    
    override func draw(context: CGContext, point: CGPoint) {
        guard let label = label else { return }
        
        let offset = self.offsetForDrawing(atPoint: point)
        let size = self.size
        
        var rect = CGRect(
            origin: CGPoint(
                x: point.x + offset.x,
                y: point.y + offset.y),
            size: size)
        rect.origin.x -= size.width / 2.0
        rect.origin.y -= size.height
        
        context.saveGState()
        let clipPath = UIBezierPath(roundedRect: rect, cornerRadius: 10.0).cgPath
        
        context.setFillColor(color.cgColor)
        
        context.addPath(clipPath)
        context.setStrokeColor(UIColor.gold.cgColor)
        context.closePath()
        context.drawPath(using: .fillStroke)
        context.beginPath()
        
        if offset.y > 0 {
            rect.origin.y += self.insets.top
        } else {
            rect.origin.y += self.insets.top
        }

        rect.size.height -= self.insets.top + self.insets.bottom
        
        UIGraphicsPushContext(context)
        
        label.draw(in: rect, withAttributes: drawAttributes)
        
        UIGraphicsPopContext()
        
        context.restoreGState()
    }
    
    override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        let index = Int(entry.x)
        let rate = String(format: "%.4f", entry.y)
        let date = data[index]
        let text = """
                   Data: \(date)
                   Kurs: \(rate)
                   """
        setLabel(text)
    }
    
    func setLabel(_ newLabel: String) {
        label = newLabel
        
        drawAttributes.removeAll()
        drawAttributes[.font] = self.font
        drawAttributes[.paragraphStyle] = paragraphStyle
        drawAttributes[.foregroundColor] = self.textColor
        
        labelSize = label?.size(withAttributes: drawAttributes) ?? CGSize.zero
        
        var size = CGSize()
        size.width = labelSize.width + self.insets.left + self.insets.right
        size.height = labelSize.height + self.insets.top + self.insets.bottom
        size.width = max(minimumSize.width, size.width)
        size.height = max(minimumSize.height, size.height)
        self.size = size
    }
}
