//
//  PetFinderAPI.swift
//  SearchPetFinderPractice
//
//  Created by Kappa on 2020-05-18.
//  Copyright © 2020 qi. All rights reserved.
//

import UIKit

let bearerToken = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiJEWHVIZ0R0bVFuNm94bFdMbjNRbXQ1aU9PZGVRMWQ0U3hUdVFOa0N3TjFKNTJycmxsaiIsImp0aSI6ImZiMjhkMTdlODk3NGYwYzcyYzk1NDBjODJmOTdhYzExM2M1MTQwYmNmMjNhZTc3NzU2Y2U1YWY3ZGJlNDhlNWY3OTAxZTA1YWM2NGIxZDZiIiwiaWF0IjoxNTkwNzAwNDM2LCJuYmYiOjE1OTA3MDA0MzYsImV4cCI6MTU5MDcwNDAzNiwic3ViIjoiIiwic2NvcGVzIjpbXX0.ATF1WZ5-wOyFWAU07wtX20XdslYLUMSrKP7_Jg2ZLkzA30rjMsqmDw3yJqhou4UC8u0MFcdXKGxXMVE6KNUOevqAEvj06TZWMXmT3G4uoKi7izYg80EI0ESeUOWeJX2UIF29z5nLu6ADPfHDeRV7QvftGDE_o9DYRPN5OkwcqDxn2XdOqKLU79mPxB-OYJ42McllxR_6BXLtooBAsubbFZQyXSe0_qhPw9f27QyVU8_3roWJupZhXt_UP9KDhd-EqYJAtYPma85alvY0mjDn8v5gccUrW1k1ff94WzHkLHuVsJWfWotF_vQN9rU3tPX3U3ryZtp183N5h50F8BLiaQ"

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
