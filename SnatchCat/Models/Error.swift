//
//  Error.swift
//  SnatchCat
//
//  Created by Qi Liu on 2020-08-26.
//  Copyright © 2020 qi. All rights reserved.
//

import Foundation

enum HTTPStatusCode: Int, Error {
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case internalServerError = 500
}

enum requestError: String, Error {
    case invalidURL
    case encodeFailure
    case decodeFailure
    case dataMiss//??? 真的存在吗
    case placeholder
}

