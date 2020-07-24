//
//  Extensions.swift
//  SnatchCat
//
//  Created by Qi Liu on 2020-07-22.
//  Copyright © 2020 qi. All rights reserved.
//

import UIKit

extension UILabel {
    
    convenience init(text: String, font: UIFont, numberOfLines: Int = 1) {
        self.init()
        self.text = text
        self.font = font
        self.numberOfLines = numberOfLines
    }
}

extension UIStackView {
    convenience init(arrangedSubviews: [UIView], spacing: CGFloat = 0) {
        self.init(frame: .zero)
        self.spacing = spacing
        arrangedSubviews.forEach { self.addArrangedSubview($0) }
    }
}

