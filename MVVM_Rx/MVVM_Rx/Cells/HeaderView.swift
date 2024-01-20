//
//  HeaderView.swift
//  MVVM_Rx
//
//  Created by 박민서 on 2023/09/19.
//

import Foundation
import UIKit
import SnapKit

final class HeaderView: UICollectionReusableView {
    
    static let id = "HeaderView"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
        }
    }
    
    public func configure(title: String) {
        titleLabel.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
