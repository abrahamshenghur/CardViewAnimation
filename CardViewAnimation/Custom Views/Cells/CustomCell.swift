//
//  CustomCell.swift
//  CardViewAnimation
//
//  Created by John on 7/31/21.
//  Copyright © 2021 Brian Advent. All rights reserved.
//

import UIKit

class CustomCell: UICollectionViewCell {
    static let reuseID = "collectionCell"
    
    var data: CustomData? {
        didSet {
            guard let data = data else { return }
            websitePreviewImage.image = data.websitePreview
        }
    }
    
    let websitePreviewImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        contentView.addSubview(websitePreviewImage)
        
        let padding: CGFloat = 9
        
        NSLayoutConstraint.activate([
            websitePreviewImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            websitePreviewImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            websitePreviewImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            websitePreviewImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
        ])
    }
}
