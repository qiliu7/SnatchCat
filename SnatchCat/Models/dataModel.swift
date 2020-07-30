//
//  dataModel.swift
//  SnatchCat
//
//  Created by Kappa on 2020-05-25.
//  Copyright © 2020 qi. All rights reserved.
//

import UIKit

struct Organization: Decodable {
    let organization: OrganizationClass
}

struct OrganizationClass: Decodable {
    let name: String
    let email: String
    let phone: String
    let address: Address
    let photos: [PhotoURL]
}

class Saved {
    static var cats = [CatResult]()
}








