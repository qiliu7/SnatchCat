//
//  dataModel.swift
//  SnatchCat
//
//  Created by Kappa on 2020-05-25.
//  Copyright © 2020 qi. All rights reserved.
//

import UIKit

enum Location {
    case city(String)
    case coordinate(Double, Double)
//    case postalCode(String)
}

struct Cat {
    let name: String
    var photoURL: URL?
    var photo: UIImage?
}
