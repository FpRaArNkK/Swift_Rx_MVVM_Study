//
//  ViewController.swift
//  tip-Calculator
//
//  Created by 박민서 on 2023/09/02.
//

import UIKit
import SnapKit

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

    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        // Do any additional setup after loading the view.
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

