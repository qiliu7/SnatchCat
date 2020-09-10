//
//  SearchAnimalsResponse.swift
//  SearchPetFinderPractice
//
//  Created by Kappa on 2020-05-18.
//  Copyright © 2020 qi. All rights reserved.



import Foundation

struct SearchAnimalsResults: Codable {
    let cats: [CatResult]
    let pagination: Pagination
    
    enum CodingKeys: String, CodingKey {
        // this app only request for cat results rather then all animals
        case cats = "animals"
        case pagination
    }
}

struct AnimalResultById: Codable {
    let cat: CatResult
    enum CodingKeys: String, CodingKey {
        case cat = "animal"
    }
}

struct CatResult: Codable, Equatable {
    static func == (lhs: CatResult, rhs: CatResult) -> Bool {
        return lhs.name == rhs.name && lhs.publishedAt == rhs.publishedAt
    }
    
    var attributesDict: [String: [String]] {
        var dict = [
            "BREED": [breeds.primary],
            "PHYSICAL CHARACTERISTICS": [size, gender, age, coat, colors.primary].compactMap { $0 }
        ]
        var environmentDict: [String: [String]] = ["BEHAVIORAL CHARACTERISTICS": []]
        environment.dict.forEach { (key, value) in
            if let value = value {
                if value {
                    environmentDict["BEHAVIORAL CHARACTERISTICS"]?.append(key)
                }
            }
        }
        var healthDict: [String: [String]] = ["HEALTH": []]
        attributes.dict.forEach { (key, value) in
            if let value = value {
                if value {
                    healthDict["HEALTH"]?.append(key)
                }
            }
        }
        dict.merge(healthDict) { current, _ in return current }
        dict.merge(environmentDict) { current, _ in
            return current
        }
        return dict.filter({ return $0.value.count != 0 })
    }
    
    let id: Int
    let name: String
    let breeds: Breed
    let age: String
    let url: URL
    let photoURLs: [PhotoURL]?
    let publishedAt: Date
    let description: String?
    let gender: String
    // TODO: make enum
    let size: String
    let environment: Environment
    let attributes: Attributes
    let coat: String?
    let colors: Colors
    let organizationId: String?
    enum CodingKeys: String, CodingKey {
        case photoURLs = "photos"
        case id, name, breeds, age, url, publishedAt, description, gender, size, environment, attributes, coat, colors, organizationId
    }
}

struct Pagination: Codable {
    let countPerPage: Int
    let totalCount: Int
    let currentPage: Int
    let totalPages: Int
}

struct LinksHref: Codable {
    let previous: [String: String]
    let next: [String: String]
}

struct Breed: Codable {
    let primary: String
    let secondary: String?
    let mixed: Bool?
}

struct Colors: Codable {
    let primary: String?
    let secondary: String?
    let tertiary: String?
}
struct PhotoURL: Codable {
    let small: URL?
    let medium: URL?
    let large: URL?
    let full: URL?
}

struct Video: Codable {
    let embed: String?
}

struct Attributes: Codable {
    
    var dict: [String: Bool?] {
        let dict = [
            "Spayed/neutered": spayedNeutered,
            "Declawed": declawed,
            "Vaccinations up-to-date": shotsCurrent,
            "Special Needs": specialNeeds,
            "House-trained": houseTrained
        ]
        return dict
    }
    
    let spayedNeutered: Bool?
    let houseTrained: Bool?
    let declawed: Bool?
    let specialNeeds: Bool?
    let shotsCurrent: Bool?
}

struct Environment: Codable {
    
    var dict: [String: Bool?] {
        let dict = [
            "Good with kids": children,
            "Good with dogs": dogs,
            "Good with cats": cats
        ]
        return dict
    }
    let children: Bool?
    let dogs: Bool?
    let cats: Bool?
}

struct Contact: Codable {
    let email: String?
    let phone: String?
    let address: Address?
}

struct Animal: Codable {
    let id: Int
    let organizationId: String
    let url: URL
    let type: String
    // should be enum?
    let species: String
    let breeds: Breed
    let colors: Colors
    let age: String
    let gender: String
    let size: String?
    let coat: String?
    let name: String
    let description: String?
    let photos: [PhotoURL]?
    
    let videos: [Video]?
    
    let status: String?
    let statusChangedAt: String?
    let attributes: Attributes
    let environment: Environment
    let tags: [String]?
    let contact: Contact
    
    // could be time?
    let publishedAt: String?
    let distance: Float?
//    let _links: Links
}

// MARK: - Address
struct Address: Codable {
    let address1: String
    let address2: String?
    let city, state, postcode, country: String
}


