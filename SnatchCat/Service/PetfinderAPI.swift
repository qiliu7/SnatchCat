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

class PetfinderAPI: NSObject {
    
    
    static let shared = PetfinderAPI()
    // MARK: ???
    static var bearToken = "" 
//    // MARK: ???
//    enum Error: Swift.Error {
//        case unknownAPIResponse
//        case generic
//    }
//
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
        //            return componenresults.url
        //        }
    }
    
    func requestAccessToken(completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let url = Endpoint.getAccessToken.url else {
            dispatchToMain {
                completion(.failure(requestError.invalidURL))
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
                completion(.failure(requestError.encodeFailure))
            }
        }
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            //TODO: need to know whats inside error
            if let error = error {
                let res = response as! HTTPURLResponse
                dispatchToMain {
                    print(error)
                    completion(.failure(res.status!))
                }
                return
            }
            guard let _ = response, let data = data else {
                dispatchToMain {
                    // MARK: ??
                    completion(.failure(requestError.dataMiss))
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let results = try decoder.decode(TokenResponse.self, from: data)
                PetfinderAPI.bearToken = results.accessToken
                dispatchToMain {
                    completion(.success(true))
                }
            } catch {
                dispatchToMain {
                    completion(.failure(requestError.decodeFailure))
                }
                return
            }
        }.resume()
    }
    
    // MARK：here or in endpoint?
    func searchAnimals(at location: String, completion: @escaping (Result<SearchAnimalsResults, Error>) -> Void) {
        //        let queryItems = [URLQueryItem(name: "location", value: location)]
        //        let endpoint = Endpoint(queryItems: queryItems)
        let endpoint = Endpoint.search(location: location)
        guard let searchURL = endpoint.url else {
            completion(.failure(requestError.invalidURL))
            return
        }
        
        var searchRequest = URLRequest(url: searchURL)
        searchRequest.httpMethod = "GET"
        searchRequest.setValue("Bearer \(PetfinderAPI.bearToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: searchRequest) { (data, response, error) in
            if let error = error {
                dispatchToMain {
                    print(error)
                    completion(.failure(requestError.placeholder))
                }
                return
            }
            guard let _ = response, let data = data else {
                dispatchToMain {
                    completion(.failure(requestError.dataMiss))
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
                    completion(.success(results))
                }
            } catch {
                dispatchToMain {
                    completion(.failure(requestError.decodeFailure))
                }
            }
        }.resume()
    }
    
    func fetchOrganizationInfo(id: String, completion: @escaping (Result<Organization, Error>) -> Void) {
        guard let url = URL(string: "https://api.petfinder.com/v2/organizations/\(id)") else { return }
        fetchGenericJSONData(url: url, completion: completion)
    }
    
    func fetchGenericJSONData<T: Decodable>(url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(PetfinderAPI.bearToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, resp, err) in
            if err != nil {
                let res = resp as! HTTPURLResponse
                dispatchToMain {
                    completion(.failure(res.status!))
                }
                return
            }
            guard let data = data else {
                dispatchToMain {
                    completion(.failure(requestError.placeholder))
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
                // some might be deleted and return 404 later
                let object = try decoder.decode(T.self, from: data)
                dispatchToMain {
                    completion(.success(object))
                }
            } catch {
                do {
                    let responseObject = try decoder.decode(PetfinderResponse.self, from: data)
                    dispatchToMain {
                        completion(.failure(responseObject))
                    }
                } catch {
                    dispatchToMain {
                        completion(.failure(requestError.decodeFailure))
                    }
                }
            }
        }.resume()
    }

    
    func getAnimal(id: Int, completion: @escaping (Result<AnimalResultById, Error>) -> Void) {
        guard let url = Endpoint.getAnimal(id: id).url else { return }
        fetchGenericJSONData(url: url, completion: completion)
        //        var request = URLRequest(url: url)
        //        request.httpMethod = "GET"
        //        request.setValue("Bearer \(PetfinderAPI.bearToken)", forHTTPHeaderField: "Authorization")
        //
        //        URLSession.shared.dataTask(with: request) { (data, resp, err) in
        //            <#code#>
        //        }
    }
}
