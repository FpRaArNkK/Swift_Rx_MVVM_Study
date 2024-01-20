//
//  LisCollectionViewCell.swift
//  MVVM_Rx
//
//  Created by 박민서 on 2023/09/19.
//

import Foundation
import UIKit
import Kingfisher

final class ListCollectionViewCell : UICollectionViewCell {
    
    static let id = "ListCollectionViewCell"
    
    let posterImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    let titleLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    let releaseDateLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [
            posterImage,
            titleLabel,
            releaseDateLabel
        ].forEach { self.addSubview($0) }
        
        posterImage.snp.makeConstraints {
            $0.top.bottom.leading.equalToSuperview()
            $0.width.equalTo(posterImage.snp.height)
//            $0.width.equalToSuperview().multipliedBy(0.3)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(posterImage.snp.trailing).offset(8)
            $0.top.equalToSuperview()
        }
        
        releaseDateLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
        }
        
        
    }
    
    public func configure(title: String, releaseDate: String, imageURL: String) {
        posterImage.kf.setImage(with: URL(string: imageURL))
        titleLabel.text = title
        releaseDateLabel.text = releaseDate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
