//
//  MenuListViewModel.swift
//  RxSwift+MVVM
//
//  Created by 박민서 on 2023/10/01.
//  Copyright © 2023 iamchiwon. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
//    var menus: [Menu] = [
//    Menu(name: "asdf", price: 100, count: 0),
//    Menu(name: "fwqw", price: 200, count: 0),
//    Menu(name: "xzcc", price: 300, count: 0),
//    Menu(name: "fewf", price: 400, count: 0),
//    ]
    
//    var itemsCount: Int = 5
////    var totalPrice: Observable<Int> = Observable.just(10_000)
//    var totalPrice: PublishSubject<Int> = PublishSubject()

class MenuListViewModel {
    
    lazy var menuObservable = BehaviorRelay<[Menu]>(value: [])
    
    lazy var itemCount = menuObservable.map {
        $0.map { $0.count }.reduce(0, +)
    }
    
    lazy var totalPrice = menuObservable.map {
        $0.map { $0.price * $0.count }.reduce(0, +)
    }
    
    init() {
        
        _ = APIService.fetchAllMenusRx()
            .map { data -> [MenuItem] in
                struct Response: Decodable {
                    let menus: [MenuItem]
                }
                let response = try! JSONDecoder().decode(Response.self, from: data)
                return response.menus
            }
            .map { menuItems -> [Menu] in
                var menus:[Menu] = []
                menuItems.enumerated().forEach { (index, item) in
                    let menu = Menu.fromMenuItems(id: index, item: item)
                    menus.append(menu)
                }
                return menus
            }
            .take(1)
            .bind(to: menuObservable)
        
//        var menus: [Menu] = [
//        Menu(id: 0, name: "asdf", price: 100, count: 0),
//        Menu(id: 1, name: "fwqw", price: 200, count: 0),
//        Menu(id: 2, name: "xzcc", price: 300, count: 0),
//        Menu(id: 3, name: "fewf", price: 400, count: 0),
//        ]
//
//        menuObservable.onNext(menus)
    }
    
    func clearAllItemSelection() {
        _ = menuObservable
            .map { menus in
                menus.map { m in
                    Menu(id: m.id, name: m.name, price: m.price, count: 0) // count만 0으로 바꿔주는겁니다 나머지 그대로
                }
            }
            .take(1) // 1번만 subscribe 내용 진행하고 stream 종료
            .subscribe(onNext: {
                self.menuObservable.onNext($0)
                self.menuObservable.accept($0)
            })
    }
    // just를 쓰지 않는 이유는 just가 Observable을 complete까지 해버려서 그럼
    
    func changeCount(item: Menu, increase: Int) {
        _ = menuObservable
            .map { menus in
                menus.map { m in
                    if m.id == item.id {
                        return Menu(id: m.id,
                                    name: m.name,
                                    price: m.price,
                                    count: max(m.count + increase, 0))
                    } else {
                        return Menu(id: m.id, name: m.name, price: m.price, count: m.count )
                    }
                }
            }
            .take(1)
            .subscribe(onNext: {
                self.menuObservable.onNext($0)
            })
    }
}
