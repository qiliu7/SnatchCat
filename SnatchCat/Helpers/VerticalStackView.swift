//
//  VerticalStackView.swift
//  SnatchCat
//
//  Created by Qi Liu on 2020-07-22.
//  Copyright © 2020 qi. All rights reserved.
//

import UIKit

class VerticalStackView: UIStackView {
    
    init(arrangedViews: [UIView], spacing: CGFloat = 0) {
        super.init(frame: .zero)
        self.spacing = spacing
        self.axis = .vertical
        arrangedViews.forEach { addArrangedSubview($0)}
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
