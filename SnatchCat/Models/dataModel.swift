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

struct CatProfile {
    let cat: Cat
    var photo: UIImage?
}

struct Cat: Codable {
    var name: String
    var breeds: Breed
    var age: String
    var photoURLs: [PhotoURL]?
    
    enum CodingKeys: String, CodingKey {
        case photoURLs = "photos", name, breeds, age
    }
}
