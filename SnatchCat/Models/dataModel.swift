//
//  dataModel.swift
//  SnatchCat
//
//  Created by Kappa on 2020-05-25.
//  Copyright © 2020 qi. All rights reserved.
//

import UIKit

//enum Location {
//    case city(String)
//    case coordinate(Double, Double)
////    case postalCode(String)
//}

struct CatProfile {
    let cat: Cat
    var photo: UIImage?
}

struct Cat: Codable {
    let name: String
    let breeds: Breed
    let age: String
    let photoURLs: [PhotoURL]?
    let publishedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case photoURLs = "photos", name, breeds, age, publishedAt
    }
}
