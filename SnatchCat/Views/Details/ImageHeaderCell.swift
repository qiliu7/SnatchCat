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
//            imageView.sd_setImage(with: cat?.photoURLs?.first?.full)
            horizontalImagesController.cat = cat
        }
    }
    
//    let imageView: UIImageView = {
//        let iv = UIImageView()
//        return iv
//    }()
    let horizontalImagesController = HorizontalHeaderController()
//    let pageControl = UIPageControl()
    // TODO: add shadow to buttons
    let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .red
        button.setImage(UIImage(systemName: "heart.fill"), for: .highlighted)
        button.constrainWidth(constant: 60)
        button.constrainHeight(constant: 60)
        button.layer.cornerRadius = 30
        button.clipsToBounds = true
        button.backgroundColor = .white
        button.isUserInteractionEnabled = true
        
        return button
    }()
    
    @objc private func buttonTappedHandler(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            saveToFavHandler?()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        addSubview(imageView)
//        imageView.contentMode = .scaleAspectFill
//        imageView.clipsToBounds = true
//        imageView.fillSuperview()
//        addSubview(pageControl)
//        pageControl.centerInSuperview()
        addSubview(horizontalImagesController.view)
        horizontalImagesController.view.fillSuperview()
        addSubview(likeButton)
        likeButton.anchor(top: nil, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 10, right: 20))
        likeButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buttonTappedHandler(_:))))
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
