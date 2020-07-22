//
//  ImageHeaderCell.swift
//  SnatchCat
//
//  Created by Qi Liu on 2020-07-22.
//  Copyright © 2020 qi. All rights reserved.
//

import UIKit

class ImageHeaderCell: UICollectionViewCell {
    
    var cat: CatResult? {
        didSet {
            imageView.sd_setImage(with: cat?.photoURLs?.first?.full)
        }
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        backgroundColor = .red
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
