//
//  PetFinderAPI.swift
//  SearchPetFinderPractice
//
//  Created by Kappa on 2020-05-18.
//  Copyright © 2020 qi. All rights reserved.
//

import UIKit

let bearerToken = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiJEWHVIZ0R0bVFuNm94bFdMbjNRbXQ1aU9PZGVRMWQ0U3hUdVFOa0N3TjFKNTJycmxsaiIsImp0aSI6ImM4Y2E2ZmYzOTQ1NDFjYjA3NTBhZmI4YTkwYjRkMTRlYTQ4OTdmZjYzMmYxMGMyYjAzNmM4ZWVhMGE5ODFkNmNjYTcxYTA2MmRhZmVjNWQyIiwiaWF0IjoxNTkwNzA1NDkwLCJuYmYiOjE1OTA3MDU0OTAsImV4cCI6MTU5MDcwOTA5MCwic3ViIjoiIiwic2NvcGVzIjpbXX0.yN0Ev5UKPJc422dJUDjZdzQ0CvcdS0CpcWUe4h1AcfvewmuiM_Jz268wV6WqwdOVFsuKdeOXYpq-pg66-DlNKkXEFey9zZunQwiXwNf0O9g5dU17y1y_gy9FXHAkpA7PbIWe4suZkKAq5SY2CTFUp2xTJs0E0Jilcu1vL2LRJ3zE9IZkG0YcDOypfQYMjtasxoeXEfohGh-DJXnM9zYeB14RSAFOOmPwPuNqBUC4X_u0sk1p46Ha_KzsOCGvTRgM_WqIXGwGfTPw2pLY3L8-kkW__rk7X8Cxizn4E5zoY2OBexXunISW67_G0aFuFkfOD7zCZ3gTnV-LyiRBO-QZ0A"

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
