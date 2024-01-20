//
//  ViewController.swift
//  tip-Calculator
//
//  Created by 박민서 on 2023/09/02.
//

import UIKit
import SnapKit
import Combine

class CalculatorVC: UIViewController {
    
    private let logoView = LogoView()
    private let resultView = ResultView()
    private let billInputView = BillInputView()
    private let tipInputView = TipInputView()
    private let splitInputView = SplitInputView()
    
    private lazy var vStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            logoView,
            resultView,
            billInputView,
            tipInputView,
            splitInputView,
            UIView()    // role as SPACER in SwiftUI
        ])
        stackView.axis = .vertical
        stackView.spacing = 36
        return stackView
    }()
    
    private let vm = CalculatorVM()
    private var cancellables = Set<AnyCancellable>()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        bind()
        // Do any additional setup after loading the view.
    }
    
    private func bind() {
        
//        billInputView.valuePublisher.sink { bill in
//            print("bill : \(bill)")
//        }.store(in: &cancellables)
        
        let input = CalculatorVM.Input(
            billPublisher: billInputView.valuePublisher,
            tipPublisher: tipInputView.valuePublihser,
            splitPublisher: Just(5).eraseToAnyPublisher())
        
        let output = vm.transform(input: input)
        
        output.updateViewPublisher.sink { result in
            print(">>>> \(result)")
        }.store(in: &cancellables)
    }
    
    private func layout() {
        self.view.backgroundColor = ThemeColor.bg
        self.view.addSubview(vStackView)
        
        vStackView.snp.makeConstraints {
            $0.leading.top.equalTo(self.view.safeAreaLayoutGuide).offset(16)
            $0.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-16)
        }
        
        logoView.snp.makeConstraints {
            $0.height.equalTo(48)
        }
        
        resultView.snp.makeConstraints {
            $0.height.equalTo(224)
        }
        
        billInputView.snp.makeConstraints {
            $0.height.equalTo(56)
        }
        
        tipInputView.snp.makeConstraints {
            $0.height.equalTo(56+16+56)
        }
        
        splitInputView.snp.makeConstraints {
            $0.height.equalTo(56)
        }
    }

}

