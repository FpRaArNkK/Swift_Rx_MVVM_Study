//
//  BillInputView.swift
//  tip-Calculator
//
//  Created by 박민서 on 2023/09/02.
//

import Foundation
import UIKit
import SnapKit

class BillInputView: UIView {
    
    private let headerView: HeaderView = {
        let view = HeaderView()
        view.configure(topText: "Enter", bottomText: "your bill")
        return view
    }()
    
    private let textFieldContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.addCornerRadius(raidus: 8.0)
        return view
    }()
    
    private let currencyDenominaitonLabel: UILabel = {
        let label = LabelFactory.build(text: "$", font: ThemeFont.bold(ofSize: 24))
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.font = ThemeFont.demibold(ofSize: 28)
        textField.keyboardType = .decimalPad
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textField.tintColor = ThemeColor.text
        textField.textColor = ThemeColor.text
        //Add Toolbar
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 36))
        toolBar.barStyle = .default
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonTapped))
        toolBar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            doneButton
        ]
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView =  toolBar
        return textField
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
            textFieldContainerView
        ].forEach { self.addSubview($0) }
        
        headerView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalTo(textFieldContainerView)
            $0.width.equalTo(68)
            $0.height.equalTo(24)
            $0.trailing.equalTo(textFieldContainerView.snp.leading).offset(-24)
        }
        
        textFieldContainerView.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
        }
        
        [
            currencyDenominaitonLabel,
            textField
        ].forEach { textFieldContainerView.addSubview($0) }
        
        currencyDenominaitonLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.leading.equalTo(textFieldContainerView.snp.leading).offset(16)
        }
        
        textField.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.leading.equalTo(currencyDenominaitonLabel.snp.trailing).offset(16)
            $0.trailing.equalTo(textFieldContainerView.snp.trailing).offset(-16)
        }
    }
    
    @objc private func doneButtonTapped() {
        textField.endEditing(true)
    }
}

