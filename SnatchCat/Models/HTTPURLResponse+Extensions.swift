//
//  HTTPURLResponse+Extensions.swift
//  SnatchCat
//
//  Created by Qi Liu on 2020-08-27.
//  Copyright © 2020 qi. All rights reserved.
//

import Foundation

extension HTTPURLResponse {
    
    var status: HTTPStatusCode? {
        return HTTPStatusCode(rawValue: statusCode)
    }
}
 
