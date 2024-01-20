//
//  CalculatorVM.swift
//  tip-Calculator
//
//  Created by 박민서 on 2023/09/11.
//

import Foundation
import Combine

class CalculatorVM {
    
    struct Input {
        // 두번째 인자는 fail때 반환하는 인자로, failure를 반환하는 일이 Never라는 뜻
        let billPublisher: AnyPublisher<Double, Never>
        let tipPublisher: AnyPublisher<Tip, Never>
        let splitPublisher: AnyPublisher<Int, Never>
    }
    
    struct Output {
//        let updateViewPublisher: AnyPublisher<(Double,Double,Double), Never>
        let updateViewPublisher: AnyPublisher<Result, Never>
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    func transform(input: Input) -> Output {
        // do Calculation in here
        
//        input.billPublisher.sink { bill in
//            print("the bill : \(bill)")
//        }.store(in: &cancellables)
        
        input.tipPublisher.sink { tip in
            print("tip : \(tip)")
        }.store(in: &cancellables)
        
        let result = Result(amountPerPerson: 500,
                            totalBill: 1000,
                            totalTip: 50)
        return Output(updateViewPublisher: Just(result).eraseToAnyPublisher())
    }
}
