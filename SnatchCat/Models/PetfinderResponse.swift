//
//  PetfinderResponseModel.swift
//  SnatchCat
//
//  Created by Qi Liu on 2020-08-23.
//  Copyright © 2020 qi. All rights reserved.
//

import Foundation

struct PetfinderResponse: Decodable, Error {
    let type: String
    let status: Int
    let title: String
    let detail: String
    let invalidParams: String?
    
    enum CodingKeys: String, CodingKey {
        case invalidParams = "invalid-params"
        case type, status, title, detail
    }
}

extension PetfinderResponse: LocalizedError {
    var errorDescription: String? {
        return title
    }
}
