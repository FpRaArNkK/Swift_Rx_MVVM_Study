//
//  SplitInputView.swift
//  tip-Calculator
//
//  Created by 박민서 on 2023/09/02.
//

import Foundation
import UIKit
import Combine
import CombineCocoa

class SplitInputView: UIView {
    
    private let headerView: HeaderView = {
        let view = HeaderView()
        view.configure(topText: "Split", bottomText: "the total")
        return view
    }()
    
    private lazy var decreamentButton: UIButton = {
        let button = buildButton(text: "-", corners: [.layerMinXMaxYCorner, .layerMinXMinYCorner])
        return button
    }()
    
    private lazy var increamentButton: UIButton = {
        let button = buildButton(text: "+", corners: [.layerMaxXMinYCorner, .layerMaxXMaxYCorner])
        button.tapPublisher.flatMap { [unowned self] _ in
            Just(self.splitSubject.value + 1)
        }.assign(to: \.value, on: splitSubject)
            .store(in: &cancellables)
        return button
    }()
    
    private lazy var quantityLabel: UILabel = {
        let label = LabelFactory.build(text: "1", font: ThemeFont.bold(ofSize: 20), backgroundColor: .white)
        return label
    }()
    
    private lazy var stackView: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [
       decreamentButton,
       quantityLabel,
       increamentButton
       ])
        stackView.axis = .horizontal
        stackView.spacing = 0
        return stackView
    }()
    
    private let splitSubject: CurrentValueSubject<Int, Never> = .init(1) //another way to init with default value
    
    var valuePublisher: AnyPublisher<Int, Never> {
        return splitSubject.eraseToAnyPublisher()
    }
    
    private var cancellables = Set<AnyCancellable>()
    
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
            stackView
        ].forEach(self.addSubview(_:))
        
        stackView.snp.makeConstraints {
            $0.top.bottom.trailing.equalToSuperview()
        }
        
        [increamentButton, decreamentButton].forEach { button in
            button.snp.makeConstraints {
                $0.width.equalTo(button.snp.height)
            }
        }
        
        headerView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalTo(stackView)
            $0.trailing.equalTo(stackView.snp.leading).offset(-24)
            $0.width.equalTo(68)
        }
    }
    
    private func buildButton(text: String, corners: CACornerMask) -> UIButton{
        let button = UIButton()
        button.setTitle(text, for: .normal)
        button.titleLabel?.font = ThemeFont.bold(ofSize: 20)
        button.backgroundColor = ThemeColor.primary
        button.addRoundedCorners(corners: corners, radius: 8.0)
        return button
    }
}
