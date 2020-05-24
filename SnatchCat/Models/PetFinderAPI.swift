//
//  PetFinderAPI.swift
//  SearchPetFinderPractice
//
//  Created by Kappa on 2020-05-18.
//  Copyright © 2020 qi. All rights reserved.
//

import Foundation

let bearerToken = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiJEWHVIZ0R0bVFuNm94bFdMbjNRbXQ1aU9PZGVRMWQ0U3hUdVFOa0N3TjFKNTJycmxsaiIsImp0aSI6IjI0MWQ2ZjAxNTg2YTM0MGRiZjcxOTNiY2EyZWIyODg1ZThhNTE1MjVkNTgxYjI4NWEyOTIzZGM4NWJlMTgxZjk2MTMyNTEyN2ExYmNiNDRiIiwiaWF0IjoxNTkwMDI3NzM0LCJuYmYiOjE1OTAwMjc3MzQsImV4cCI6MTU5MDAzMTMzNCwic3ViIjoiIiwic2NvcGVzIjpbXX0.Lt8s6NhtH36fJjkVmOvii_RD3KDWzWBpte71ykrhf1sXEbN-byM7GHc3Uvl5DO-95a7WEvqZkmytw8Z3_77j8lYPazrWSuWxfoKPxtWjGqbteXd7zTIFQB4FpkYqIXXiFMgFfVW-cfn6G4qsZTq33P7IT5CyJ49y0dEzZBmcQLJFAsgIZDioOVWiP6q42x5xV74jA8Ig8Ty1PECxUlyRM7HfkKDeILu50lFupFNORzWxu6H9xnJX83fOnJNsVfU7Zf3r0fSgzVtbNTc23AofsIM1MiB5bsRaoLIrD81jdsVzvodL_lpmTitFnMX-ZjlwhFFySN8rZ-w6Ran3d-LBvA"

class PetFinderAPI: NSObject {
  
  enum Error: Swift.Error {
    case unknownAPIResponse
    case generic
  }
  
  func searchAnimals(for searchTerm: String, completion: @escaping (Result<SearchAnimalsResults>) -> Void) {
    guard let searchURL = searchAnimalsURL(for: searchTerm) else {
      completion(Result.error(Error.unknownAPIResponse))
      return
    }
    
    var searchRequest = URLRequest(url: searchURL)
    searchRequest.httpMethod = "GET"
    searchRequest.setValue(bearerToken, forHTTPHeaderField: "Authorization")
    
    URLSession.shared.dataTask(with: searchRequest) { (data, response, error) in
      if let error = error {
        dispatchToMain {
          completion(Result.error(error))
        }
        return
      }
      
      guard let _ = response, let data = data else {
        dispatchToMain {
          completion(Result.error(Error.unknownAPIResponse))
        }
        return
      }
      
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      do {
        let results = try decoder.decode(SearchAnimalsResults.self, from: data)
        dispatchToMain {
          print(results)
        }
      } catch {
        dispatchToMain {
          print(error)
        }
      }
    }.resume()
  }
  
  // w/o searchTerm first
  private func searchAnimalsURL(for searchTerm: String) -> URL? {
    guard let escapedTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) else {
      return nil
    }
    
    let URLString = "https://api.petfinder.com/v2/animals?type=cat"
    return URL(string: URLString)
  }
}
