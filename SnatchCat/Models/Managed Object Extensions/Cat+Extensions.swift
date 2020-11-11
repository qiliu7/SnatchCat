//
//  Cat+Extensions.swift
//  SnatchCat
//
//  Created by Qi Liu on 2020-08-23.
//  Copyright © 2020 qi. All rights reserved.
//

import Foundation
import CoreData

extension Cat {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        addDate = Date()
    }
}
