//
//  TipInputView.swift
//  tip-Calculator
//
//  Created by 박민서 on 2023/09/02.
//

import Foundation
import UIKit
import SnapKit

class TipInputView: UIView {
    
    private let headerView: HeaderView = {
        let view = HeaderView()
        view.configure(topText: "Choose", bottomText: "your tip")
        return view
    }()
    
    private lazy var tenPercentTipButton: UIButton = {
        let button = buildTipButton(tip: .ten)
        return button
    }()
    
    private lazy var fifteenPercentTipButton: UIButton = {
        let button = buildTipButton(tip: .fifteen)
        return button
    }()
    
    private lazy var twentyPercentTipButton: UIButton = {
        let button = buildTipButton(tip: .twenty)
        return button
    }()
    
    private lazy var customTipButton: UIButton = {
       let button = UIButton()
        button.setTitle("Custom Tip", for: .normal)
        button.titleLabel?.font = ThemeFont.bold(ofSize: 20)
        button.backgroundColor = ThemeColor.primary
        button.tintColor = .white
        button.addCornerRadius(raidus: 8.0)
        return button
    }()
    
    private lazy var buttonVStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            buttonHStackView,
            customTipButton
        ])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var buttonHStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            tenPercentTipButton,
            fifteenPercentTipButton,
            twentyPercentTipButton
        ])
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        stackView.axis = .horizontal
        return stackView
    }()
    
    init() {
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
       [
        headerView,
        buttonVStackView
       ].forEach { self.addSubview($0) }
        
        buttonVStackView.snp.makeConstraints {
            $0.top.bottom.trailing.equalToSuperview()
        }
        
        headerView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(buttonVStackView.snp.leading).offset(-24)
            $0.width.equalTo(68)
            $0.centerY.equalTo(buttonHStackView)
        }
        
        
    }
    
    private func buildTipButton(tip: Tip) -> UIButton {
        let button = UIButton(type: .custom)
        button.backgroundColor = ThemeColor.primary
        button.addCornerRadius(raidus: 8.0)
        let text = NSMutableAttributedString(string: tip.stringValue, attributes: [.font : ThemeFont.bold(ofSize: 20), .foregroundColor: UIColor.white])
        text.addAttributes([.font : ThemeFont.bold(ofSize: 14)], range: NSMakeRange(2, 1))
        button.setAttributedTitle(text, for: .normal)
        return button
    }
}



