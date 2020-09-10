//
//  Cat+CoreDataProperties.swift
//  
//
//  Created by Qi Liu on 2020-09-09.
//
//

import Foundation
import CoreData


extension Cat {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Cat> {
        return NSFetchRequest<Cat>(entityName: "Cat")
    }

    @NSManaged public var addDate: Date?
    @NSManaged public var age: String?
    @NSManaged public var attributes: [String: [String]]?
    @NSManaged public var breeds: Breed?
    @NSManaged public var coat: String?
    @NSManaged public var gender: String?
    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var organizationId: String?
    @NSManaged public var photoURLs: [PhotoURL]?
    @NSManaged public var publishedAt: Date?
    @NSManaged public var simpleDescription: String?
    @NSManaged public var size: String?
    @NSManaged public var url: String?
    @NSManaged public var list: FavoritesList?

}
