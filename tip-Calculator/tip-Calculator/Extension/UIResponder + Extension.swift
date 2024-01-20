//
//  UIResponder + Extension.swift
//  tip-Calculator
//
//  Created by 박민서 on 2023/09/11.
//

import UIKit

extension UIResponder {
    var parentViewController: UIViewController? {
        return next as? UIViewController ?? next?.parentViewController
    }
}
