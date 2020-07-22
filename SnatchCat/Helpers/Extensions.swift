//
//  Extensions.swift
//  SnatchCat
//
//  Created by Qi Liu on 2020-07-22.
//  Copyright © 2020 qi. All rights reserved.
//

import UIKit

extension UILabel {
    
    convenience init(text: String, font: UIFont) {
        self.init()
        self.text = text
        self.font = font
    }
}
