//
//  PetFinderAPI.swift
//  SearchPetFinderPractice
//
//  Created by Kappa on 2020-05-18.
//  Copyright © 2020 qi. All rights reserved.
//

import UIKit

class PetfinderAPI: NSObject {
    
    static let shared = PetfinderAPI()
    static var bearerToken = ""

    enum Endpoint {
        static let base = "https://api.petfinder.com/v2"

        case getAccessToken
        case getAnimal(id: Int)
        case search(location: String)
        
        // MARK: hard coded for now, may change for filters
        var urlString: String {
            switch self {
            case .getAccessToken:
                return Endpoint.base + "/oauth2/token"
            case .getAnimal(id: let id):
                return Endpoint.base + "/animals/\(id)"
            case .search(location: var location):
                location = location.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                return Endpoint.base + "/animals?type=cat&location=\(location)"
            }
        }
        
        var url: URL? {
            return URL(string: urlString)
        }
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
        let auth = Auth(grantType: "client_credentials", clientID: PetfinderAPI.apiKey, clientSecret: PetfinderAPI.clientSecret)
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
                    completion(.failure(requestError.dataMiss))
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let results = try decoder.decode(TokenResponse.self, from: data)
                PetfinderAPI.bearerToken = results.accessToken
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
    

    func searchAnimals(at location: String, completion: @escaping (Result<SearchAnimalsResults, Error>) -> Void) {

        let endpoint = Endpoint.search(location: location)
        guard let searchURL = endpoint.url else {
            completion(.failure(requestError.invalidURL))
            return
        }
        
        var searchRequest = URLRequest(url: searchURL)
        searchRequest.httpMethod = "GET"
        searchRequest.setValue("Bearer \(PetfinderAPI.bearerToken)", forHTTPHeaderField: "Authorization")
        
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
                do {
                    let responseObject = try decoder.decode(ErrorResponse.self, from: data)
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
    
    func fetchOrganizationInfo(id: String, completion: @escaping (Result<Organization, Error>) -> Void) {
        guard let url = URL(string: "https://api.petfinder.com/v2/organizations/\(id)") else { return }
        fetchGenericJSONData(url: url, completion: completion)
    }
    
    func fetchGenericJSONData<T: Decodable>(url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(PetfinderAPI.bearerToken)", forHTTPHeaderField: "Authorization")
        
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
                // TODO: handle of: some might be deleted and return 404 later
                let object = try decoder.decode(T.self, from: data)
                dispatchToMain {
                    completion(.success(object))
                }
            } catch {
                do {
                    let responseObject = try decoder.decode(ErrorResponse.self, from: data)
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
    }
}
