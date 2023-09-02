//
//  UIView + Extension.swift
//  tip-Calculator
//
//  Created by 박민서 on 2023/09/03.
//

import Foundation
import UIKit

extension UIView {
    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = false
        self.layer.shadowOffset = offset
        self.layer.shadowColor = color.cgColor
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity
        let backgroundCGColor = backgroundColor?.cgColor
        self.backgroundColor = nil
        self.layer.backgroundColor = backgroundCGColor
    }
    
    func addCornerRadius(raidus: CGFloat) {
        layer.masksToBounds = false
        layer.cornerRadius = raidus
    }
    
    func addRoundedCorners(corners: CACornerMask, radius: CGFloat) {
        layer.cornerRadius = radius
        layer.maskedCorners = [corners]
    }
}
