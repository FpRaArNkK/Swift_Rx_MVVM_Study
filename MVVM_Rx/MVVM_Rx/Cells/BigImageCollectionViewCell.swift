//
//  BigImageCollectionViewCell.swift
//  MVVM_Rx
//
//  Created by 박민서 on 2023/09/19.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher

final class BigImageCollectionViewCell: UICollectionViewCell {
    
    static let id = "BigImageCollectionViewCell"
    
    private let posterImage = UIImageView()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    let titleLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    let reviewLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    let descLabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.font = .systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [
            titleLabel,
            reviewLabel,
            descLabel
        ].forEach { stackView.addArrangedSubview($0) }
        
        [
            posterImage,
            stackView
        ].forEach { self.addSubview($0) }
        
        posterImage.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(500)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(posterImage.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(14)
            $0.trailing.bottom.equalToSuperview().offset(-14)
        }
        
    }
    
    public func configure(title: String, review: String, desc: String, imageURL: String) {
        posterImage.kf.setImage(with: URL(string: imageURL))
        titleLabel.text = title
        reviewLabel.text = review
        descLabel.text = desc
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
