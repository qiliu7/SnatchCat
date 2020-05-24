//
//  SearchAnimalsResponse.swift
//  SearchPetFinderPractice
//
//  Created by Kappa on 2020-05-18.
//  Copyright © 2020 qi. All rights reserved.



import Foundation

struct SearchAnimalsResults: Codable {
  let animals: [Animal]
  let pagination: Pagination
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
struct Photo: Codable {
  let small: URL?
  let medium: URL?
  let large: URL?
  let full: URL?
}

struct Video: Codable {
  let embed: String?
}

struct Attributes: Codable {
  let spayedNeutered: Bool?
  let houseTrained: Bool?
  let declawed: Bool?
  let specialNeeds: Bool?
  let shotsCurrent: Bool?
}

struct Environment: Codable {
  let children: Bool?
  let dogs: Bool?
  let cats: Bool?
}

struct Address: Codable {
  let address1: String?
  let address2: String?
  let city: String?
  let state: String?
  let postcode: String?
  let country: String?
}

struct Contact: Codable {
  let email: String?
  let phone: String?
  let address: Address?
}

// not sure
struct Links: Codable {
  let animal: [String: String]?
  let type: [String: String]?
  let organization: [String: String]?
  
  enum CodingKeys: String, CodingKey {
    case animal = "self"
    case type, organization
  }
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
  let photos: [Photo]?

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
  let _links: Links
}


