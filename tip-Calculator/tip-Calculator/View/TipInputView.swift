//
//  TipInputView.swift
//  tip-Calculator
//
//  Created by 박민서 on 2023/09/02.
//

import Foundation
import UIKit
import SnapKit
import Combine
import CombineCocoa

class TipInputView: UIView {
    
    private let headerView: HeaderView = {
        let view = HeaderView()
        view.configure(topText: "Choose", bottomText: "your tip")
        return view
    }()
    
    private lazy var tenPercentTipButton: UIButton = {
        let button = buildTipButton(tip: .ten)
        button.tapPublisher.flatMap({
            Just(Tip.ten)
        }).assign(to: \.value, on: tipSubject)
            .store(in: &cancellabels)
        return button
    }()
    
    private lazy var fifteenPercentTipButton: UIButton = {
        let button = buildTipButton(tip: .fifteen)
        button.tapPublisher.flatMap({
            Just(Tip.fifteen)
        }).assign(to: \.value, on: tipSubject)
            .store(in: &cancellabels)
        return button
    }()
    
    private lazy var twentyPercentTipButton: UIButton = {
        let button = buildTipButton(tip: .twenty)
        button.tapPublisher.flatMap({
            Just(Tip.twenty)
        }).assign(to: \.value, on: tipSubject)
            .store(in: &cancellabels)
        return button
    }()
    
    private lazy var customTipButton: UIButton = {
       let button = UIButton()
        button.setTitle("Custom Tip", for: .normal)
        button.titleLabel?.font = ThemeFont.bold(ofSize: 20)
        button.backgroundColor = ThemeColor.primary
        button.tintColor = .white
        button.addCornerRadius(raidus: 8.0)
        button.tapPublisher.sink { [weak self] _ in
            self?.handleCustomTipButton()
        }.store(in: &cancellabels)
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
    
    private let tipSubject = CurrentValueSubject<Tip,Never>(.none) // <- default val
    
    var valuePublihser: AnyPublisher<Tip,Never> {
        return tipSubject.eraseToAnyPublisher()
    }
    
    private var cancellabels = Set<AnyCancellable>()
    
    private func handleCustomTipButton() {
        let alerController: UIAlertController = {
            let controller = UIAlertController(
                title: "Enter custom tip",
                message: nil,
                preferredStyle: .alert)
            
            controller.addTextField { textField in
                textField.placeholder = "Make it generous!"
                textField.keyboardType = .numberPad
                textField.autocapitalizationType = .none
            }
            
            let cancelAction = UIAlertAction(
                title: "Cancel",
                style: .cancel)
            
            let okAction = UIAlertAction(
                title: "OK",
                style: .default) { [weak self] _ in
                    guard let text = controller.textFields?.first?.text, let value = Int(text) else { return }
                    self?.tipSubject.send(.custom(value: value))
                }
            [okAction, cancelAction].forEach(controller.addAction(_:))
            return controller
        }()
        parentViewController?.present(alerController, animated: true)
    }
    
    private func observe() {
        tipSubject.sink { [unowned self] tip in
            resetView()
            switch tip {
            case .none:
                break
            case .ten:
                tenPercentTipButton.backgroundColor = ThemeColor.secondary
            case .fifteen:
                fifteenPercentTipButton.backgroundColor = ThemeColor.secondary
            case .twenty:
                twentyPercentTipButton.backgroundColor = ThemeColor.secondary
            case .custom(let value) :
                customTipButton 0-.backgroundColor = ThemeColor.secondary
                let text = NSMutableAttributedString(
                    string: "$\(value)",
                    attributes: [.font : ThemeFont.bold(ofSize: 20)])
                text.addAttributes([.font : ThemeFont.bold(ofSize: 14)], range: NSMakeRange(0, 1))
                customTipButton.setAttributedTitle(text, for: .normal)
            }
        }.store(in: &cancellabels)
    }
    
    private func resetView() {
        [
            tenPercentTipButton,
            fifteenPercentTipButton,
            twentyPercentTipButton,
            customTipButton
        ].forEach { $0.backgroundColor = ThemeColor.primary }
        
        let text = NSMutableAttributedString(
            string: "Custom tip",
            attributes: [.font: ThemeFont.bold(ofSize: 20)])
        
        customTipButton.setAttributedTitle(text, for: .normal)
    }
    
    init() {
        super.init(frame: .zero)
        layout()
        observe()
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



