//
//  ImageHeaderCell.swift
//  SnatchCat
//
//  Created by Qi Liu on 2020-07-22.
//  Copyright © 2020 qi. All rights reserved.
//

import UIKit

class ImageHeaderCell: UICollectionViewCell {
    
    var saveToFavHandler: (() -> ())?
    
    var cat: CatResult? {
        didSet {
            guard let cat = cat else { return }
            horizontalImagesController.cat = cat
            heartButton.isLiked = Favorites.catList.contains(cat)
        }
    }
    
    let horizontalImagesController = HorizontalHeaderController()
    // TODO: add shadow to buttons
    let heartButton: HeartButton = {
        let button = HeartButton(type: .custom)
        return button
    }()
    
    @objc private func buttonTappedHandler(sender: HeartButton) {
        saveToFavHandler?()
        sender.flipLikedState()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(horizontalImagesController.view)
        horizontalImagesController.view.fillSuperview()
        addSubview(heartButton)
        heartButton.constrainHeight(constant: 60)
        heartButton.constrainWidth(constant: 60)
        heartButton.imageView?.constrainHeight(constant: 30)
        heartButton.imageView?.constrainWidth(constant: 30)
        heartButton.anchor(top: nil, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 10, right: 20))
        heartButton.addTarget(self, action: #selector(buttonTappedHandler), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
