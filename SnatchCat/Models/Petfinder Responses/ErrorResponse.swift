//
//  ErrorResponse.swift
//  SnatchCat
//
//  Created by Qi Liu on 2020-11-18.
//  Copyright © 2020 qi. All rights reserved.
//

import Foundation

struct ErrorResponse: Codable {
    let type: String
    let status: Int
    let title: String
    let detail: String
    let invalidParams: [InvalidParams]
    
    enum CodingKeys: String, CodingKey {
        case type, status, title, detail
        case invalidParams = "invalid-params"
    }
}

struct InvalidParams: Codable {
    let invalidParamIn: String
    let path: String
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case invalidParamIn = "in"
        case path, message
    }
}

extension ErrorResponse: LocalizedError {
    var errorDescription: String? {
        return invalidParams[0].message
    }
}
