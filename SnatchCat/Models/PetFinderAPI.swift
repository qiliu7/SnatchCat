//
//  PetFinderAPI.swift
//  SearchPetFinderPractice
//
//  Created by Kappa on 2020-05-18.
//  Copyright © 2020 qi. All rights reserved.
//

import UIKit

let bearerToken = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiJEWHVIZ0R0bVFuNm94bFdMbjNRbXQ1aU9PZGVRMWQ0U3hUdVFOa0N3TjFKNTJycmxsaiIsImp0aSI6IjI0MWQ2ZjAxNTg2YTM0MGRiZjcxOTNiY2EyZWIyODg1ZThhNTE1MjVkNTgxYjI4NWEyOTIzZGM4NWJlMTgxZjk2MTMyNTEyN2ExYmNiNDRiIiwiaWF0IjoxNTkwMDI3NzM0LCJuYmYiOjE1OTAwMjc3MzQsImV4cCI6MTU5MDAzMTMzNCwic3ViIjoiIiwic2NvcGVzIjpbXX0.Lt8s6NhtH36fJjkVmOvii_RD3KDWzWBpte71ykrhf1sXEbN-byM7GHc3Uvl5DO-95a7WEvqZkmytw8Z3_77j8lYPazrWSuWxfoKPxtWjGqbteXd7zTIFQB4FpkYqIXXiFMgFfVW-cfn6G4qsZTq33P7IT5CyJ49y0dEzZBmcQLJFAsgIZDioOVWiP6q42x5xV74jA8Ig8Ty1PECxUlyRM7HfkKDeILu50lFupFNORzWxu6H9xnJX83fOnJNsVfU7Zf3r0fSgzVtbNTc23AofsIM1MiB5bsRaoLIrD81jdsVzvodL_lpmTitFnMX-ZjlwhFFySN8rZ-w6Ran3d-LBvA"

class PetFinderAPI: NSObject {
    
    enum Error: Swift.Error {
        case unknownAPIResponse
        case generic
    }
    
    struct Endpoint {
        //    let base = "https://api.petfinder.com/v2/animals"
        let scheme = "https"
        let host = "api.petfinder.com"
        let path = "/v2/animals"
        // MARK: Query Items
        var queryItems: [URLQueryItem]
        
        var url: URL? {
            var components = URLComponents()
            components.scheme = scheme
            components.host = host
            components.path = path
            components.queryItems = queryItems
            // MARK: may not belong here...
            components.queryItems?.append(URLQueryItem(name: "type", value: "cat"))
            return components.url
        }
    }
    
    // MARK：here or in endpoint?
    func searchAnimals(at location: Location, completion: @escaping (Result<SearchAnimalsResults>) -> Void) {
        var queryItems = [URLQueryItem]()
        
        switch location {
        case .city(let city):
            queryItems.append(URLQueryItem(name: "city", value: "\(city)"))
        case let .coordinate(lat, lon):
            queryItems.append(URLQueryItem(name: "latitude", value: "\(lat)"))
            queryItems.append(URLQueryItem(name: "longitude", value: "\(lon)"))
        }
        
        let endpoint = Endpoint(queryItems: queryItems)
        guard let searchURL = endpoint.url else {
            completion(Result.error(Error.unknownAPIResponse))
            return
        }
        print(searchURL)
        
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
                    completion(Result.results(results))
                }
            } catch {
                dispatchToMain {
                    completion(Result.error(error))
                }
            }
        }.resume()
    }
    
    func downloadPhoto(url: URL, completion: @escaping (Result<UIImage>) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(Result.error(error))
            }
            if let data = data, let photo = UIImage(data: data) {
                completion(Result.results(photo))
            }
        }.resume()
    }
}
