//
//  NameCell.swift
//  SnatchCat
//
//  Created by Qi Liu on 2020-07-22.
//  Copyright © 2020 qi. All rights reserved.
//

import UIKit

class NameCell: UICollectionViewCell {
    
    var cat: CatResult? {
        didSet {
            guard let cat = cat else { return }
            nameLabel.text = cat.name
            infoLabel.text = cat.age + " • " + cat.breeds.primary
        }
    }
    
    let nameLabel: UILabel = {
        let label = UILabel(text: "Cat Name", font: .boldSystemFont(ofSize: 20))
        return label
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel(text: "Kitten • Domestic Short Hair", font: .systemFont(ofSize: 16))
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stackView = VerticalStackView(arrangedViews: [
            nameLabel, infoLabel
        ], spacing: 8)
        stackView.alignment = .center
        addSubview(stackView)
        stackView.fillSuperview(padding: UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0))
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
