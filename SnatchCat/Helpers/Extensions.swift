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

extension String {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: Data(utf8), options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print(error)
            return nil
        }
    }
    var unicodes: [UInt32] { return unicodeScalars.map{$0.value} }
}

