//
//  DescriptionCell.swift
//  SnatchCat
//
//  Created by Qi Liu on 2020-07-22.
//  Copyright © 2020 qi. All rights reserved.
//

import UIKit

class DescriptionCell: UICollectionViewCell {
    
    var cat: CatResult? {
        didSet {
            guard let cat = cat else { return }
            imageView.sd_setImage(with: cat.photoURLs?.first?.full)
            titleLabel.text = "Meet \(cat.name)"
            descriptionLabel.text = cat.description
            askAboutButton.setTitle("ASK ABOUT \(cat.name.uppercased())", for: .normal)
        }
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "noImageAvailable"))
        iv.constrainWidth(constant: 50)
        iv.constrainHeight(constant: 50)
        iv.layer.cornerRadius = 25
        iv.clipsToBounds = true
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel(text: "Meet Toffee", font: .boldSystemFont(ofSize: 20))
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel(text: "Toffee is the runt...", font: .systemFont(ofSize: 16))
        label.numberOfLines = 0
        return label
    }()
    
    let askAboutButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle("ASK ABOUT TOFFEE", for: .normal)
        button.backgroundColor = .purple
        button.setTitleColor(.white, for: .normal)
        button.constrainHeight(constant: 32)
        button.constrainWidth(constant: 350)
        button.layer.cornerRadius = 16
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stackView = VerticalStackView(arrangedViews: [
            UIStackView(arrangedSubviews: [
            UIView(), imageView, UIView()
            ]),
            titleLabel, descriptionLabel, askAboutButton
        ], spacing: 16)
        stackView.alignment = .center
        
        addSubview(stackView)
        stackView.fillSuperview(padding: UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
