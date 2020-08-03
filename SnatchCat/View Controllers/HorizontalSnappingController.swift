//
//  HorizontalSnappingController.swift
//  AppStoreJSONAPIs
//
//  Created by Qi Liu on 2020-07-12.
//  Copyright © 2020 qi. All rights reserved.
//

import UIKit

class HorizontalSnappingController: UICollectionViewController {
    
    init() {
        let layout = BetterSnappingLayout()
        layout.scrollDirection = .horizontal
        super.init(collectionViewLayout: layout)
        collectionView.decelerationRate = .fast
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
