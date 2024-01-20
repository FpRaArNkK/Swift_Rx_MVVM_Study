//
//  ButtonView.swift
//  MVVM_Rx
//
//  Created by 박민서 on 2023/09/17.
//

import Foundation
import UIKit
import SnapKit

class ButtonView: UIView {
    
    let tvButton: UIButton = {
        let button = UIButton()
        button.setTitle("TV", for: .normal)
        button.setTitleColor(.black, for: .normal)
        
        button.configuration = UIButton.Configuration.bordered()
        return button
    }()
    
    let movieButton: UIButton = {
        let button = UIButton()
        button.setTitle("Movie", for: .normal)
        button.setTitleColor(.black, for: .normal)
        
        button.configuration = UIButton.Configuration.bordered()
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    private func setUI() {
        [
            tvButton,
            movieButton,
        ].forEach { self.addSubview($0)}
        
        tvButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }
        
        movieButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(tvButton.snp.trailing).offset(10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

