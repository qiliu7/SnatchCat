//
//  Result.swift
//  SearchPetFinderPractice
//
//  Created by Kappa on 2020-05-18.
//  Copyright © 2020 qi. All rights reserved.
//

import Foundation

enum Result<ResultType> {
  case results(ResultType)
  case error(Error)
}
