//
//  Auth.swift
//  SnatchCat
//
//  Created by Kappa on 2020-06-03.
//  Copyright © 2020 qi. All rights reserved.
//

import Foundation

struct Auth: Codable {
    let grantType: String
    let clientID: String
    let clientSecret: String
    
    enum CodingKeys: String, CodingKey {
        case grantType = "grant_type"
        case clientID = "client_id"
        case clientSecret = "client_secret"
    }
}

struct TokenResponse: Codable {
    let tokenType: String
    let expiresIn: Int
    let accessToken: String
    
    enum CodingKeys: String, CodingKey {
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case accessToken = "access_token"
    }
}
