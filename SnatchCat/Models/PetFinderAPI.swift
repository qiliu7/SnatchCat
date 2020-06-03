//
//  PetFinderAPI.swift
//  SearchPetFinderPractice
//
//  Created by Kappa on 2020-05-18.
//  Copyright © 2020 qi. All rights reserved.
//

import UIKit

let bearerToken = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiJEWHVIZ0R0bVFuNm94bFdMbjNRbXQ1aU9PZGVRMWQ0U3hUdVFOa0N3TjFKNTJycmxsaiIsImp0aSI6ImQyMGIwZjA4ZTI2MTc1NjVhNzBjNmY3YTViZWE2ODIwNTU3Mjc0NzIyYzk2M2IzMGQ2MWIzMTg5NGQ4MTRkNjU4OWE4MjQ2NDViY2RmM2VkIiwiaWF0IjoxNTkxMjE0NDUwLCJuYmYiOjE1OTEyMTQ0NTAsImV4cCI6MTU5MTIxODA1MCwic3ViIjoiIiwic2NvcGVzIjpbXX0.Kyh9tAHZawtTYwS4PqUx163DF69-1R3YfBiZkv47uYrfSRwyoeTcHCc2CLTbH7QRN3ltJVC_Gdc9tVj1-ihmNVwoKr7p2JWc9oq7STDLpjCJk5r75p1MLkRpc1oz9oZwHRg8Qs6JlORevtN_4u1m7f-PtHtVZjmhdR6o8xf0CQo2OXPYgMuyDGih7SEuWMliIGrzWwhScKa33Yf2QUv9lJ6UPChnTysATDb2fIiTpt7Fg6d_LF29FOqptAVPKGBqD6vTBSKQM-jd2hGwTcM0MerbnNz9OBDqr5-qbQnn9ElE8XJJJeocws9efjFHAquRV8nSWR3Tj1AahF_srKKtTQ"

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
    func searchAnimals(at location: String, completion: @escaping (Result<SearchAnimalsResults>) -> Void) {
        let queryItems = [URLQueryItem(name: "location", value: location)]
        
//        switch location {
//        case .city(let city):
//            queryItems.append(URLQueryItem(name: "location", value: "\(city)"))
//        case let .coordinate(lat, lon):
//            queryItems.append(URLQueryItem(name: "location", value: "\(lat),\(lon)"))
//        }
        
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
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ssZ"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            
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
