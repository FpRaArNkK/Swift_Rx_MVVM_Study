//
//  Tip.swift
//  tip-Calculator
//
//  Created by 박민서 on 2023/09/03.
//

import Foundation

enum Tip {
    case none
    case ten
    case fifteen
    case twenty
    case custom(value: Int)
    
    var stringValue: String {
        switch self {
        case .none:
            return ""
        case .ten:
            return "10%"
        case .fifteen:
            return "15%"
        case .twenty:
            return "20%"
        case .custom(let value):
            return String(value)
        }
    }
}
