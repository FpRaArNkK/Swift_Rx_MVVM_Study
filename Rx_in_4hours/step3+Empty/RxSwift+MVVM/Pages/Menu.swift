//
//  Menu.swift.swift
//  RxSwift+MVVM
//
//  Created by 박민서 on 2023/10/01.
//  Copyright © 2023 iamchiwon. All rights reserved.
//

import Foundation

struct Menu {
    var id: Int
    var name: String
    var price: Int
    var count: Int
}

extension Menu {
    static func fromMenuItems(id: Int, item: MenuItem) -> Menu {
        return Menu(id: id, name: item.name, price: item.price, count: 0)
    }
}
