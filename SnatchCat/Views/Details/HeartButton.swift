//
//  HeartButton.swift
//  SnatchCat
//
//  Created by Qi Liu on 2020-08-04.
//  Copyright © 2020 qi. All rights reserved.
//

import UIKit

class HeartButton: UIButton {
    
    var isLiked = false {
        didSet {
            let image = isLiked ? likedImage : unlikedImage
            setImage(image, for: .normal)
        }
    }
    private let likedImage = UIImage(systemName: "heart.fill")
    private let unlikedImage = UIImage(systemName: "heart")
 
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setImage(unlikedImage, for: .normal)
        self.tintColor = .red
//        imageView?.constrainWidth(constant: 30)
//        imageView?.constrainHeight(constant: 30)
        imageView?.contentMode = .scaleAspectFill
        layer.cornerRadius = 30
        clipsToBounds = true
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func flipLikedState() {
        isLiked = !isLiked
        animate()
    }
    
     private func animate() {
        UIView.animate(withDuration: 0.1) {
            let newImage = self.isLiked ? self.likedImage : self.unlikedImage
            self.setImage(newImage, for: .normal)
        }
    }
}
