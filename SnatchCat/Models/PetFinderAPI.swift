//
//  PetFinderAPI.swift
//  SearchPetFinderPractice
//
//  Created by Kappa on 2020-05-18.
//  Copyright © 2020 qi. All rights reserved.
//

import UIKit

// TODO: move somewhere else
let apiKey = "***REMOVED***"
let clientSecret = "***REMOVED***"
class PetFinderAPI: NSObject {
    // MARK: ???
    var bearToken = ""
    // MARK: ???
    enum Error: Swift.Error {
        case unknownAPIResponse
        case generic
    }
    
    enum Endpoint {
        //    let base = "https://api.petfinder.com/v2/animals"
        //        let scheme = "https"
        //        let host = "api.petfinder.com"
        //        let path = "/v2/animals"
        static let base = "https://api.petfinder.com/v2"
        //        static let apiKeyParam = "&client_id=\(apiKey)"
        //        static let clientSecretParam = "&client_secret=\(clientSecret)"
        
        case getAccessToken
        case search(location: String)
        
        // MARK: hard coded for now, may change for filters
        var urlString: String {
            switch self {
            case .getAccessToken:
                return Endpoint.base + "/oauth2/token"
            case .search(location: var location):
                location = location.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                return Endpoint.base + "/animals?type=cat&location=\(location)"
            }
        }
        
        var url: URL? {
            return URL(string: urlString)
        }
        
        //  MARK: Query Items 开放filter之后也许要用？
        //        var queryItems: [URLQueryItem]
        //
        //        var url: URL? {
        //            var components = URLComponents()
        //            components.scheme = scheme
        //            components.host = host
        //            components.path = path
        //            components.queryItems = queryItems
        //            // MARK: may not belong here...
        //            components.queryItems?.append(URLQueryItem(name: "type", value: "cat"))
        //            return components.url
        //        }
    }
    
    func requestAccessToken(completion: @escaping (Result<Bool>) -> Void) {
        guard let url = Endpoint.getAccessToken.url else {
            dispatchToMain {
                completion(Result.error(Error.generic))
            }
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        let auth = Auth(grantType: "client_credentials", clientID: apiKey, clientSecret: clientSecret)
        do {
            request.httpBody = try encoder.encode(auth)
        } catch {
            dispatchToMain {
                completion(Result.error(Error.generic))
            }
        }
        URLSession.shared.dataTask(with: request) { (data, response, error) in
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
            do {
                let results = try decoder.decode(TokenResponse.self, from: data)
                self.bearToken = results.accessToken
                dispatchToMain {
                    completion(Result.results(true))
                }
            } catch {
                dispatchToMain {
                   completion(Result.error(error))
                }
                return
            }
        }.resume()
    }
    
    // MARK：here or in endpoint?
    func searchAnimals(at location: String, completion: @escaping (Result<SearchAnimalsResults>) -> Void) {
        //        let queryItems = [URLQueryItem(name: "location", value: location)]
        //        let endpoint = Endpoint(queryItems: queryItems)
        let endpoint = Endpoint.search(location: location)
        print(endpoint)
        guard let searchURL = endpoint.url else {
            completion(Result.error(Error.unknownAPIResponse))
            return
        }
        print(searchURL)
        
        var searchRequest = URLRequest(url: searchURL)
        searchRequest.httpMethod = "GET"
        searchRequest.setValue("Bearer \(self.bearToken)", forHTTPHeaderField: "Authorization")
        
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
    
    func downloadImage(url: URL, completion: @escaping (Result<UIImage>) -> Void) {
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
