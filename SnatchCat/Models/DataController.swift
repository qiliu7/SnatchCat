//
//  DataController.swift
//  SnatchCat
//
//  Created by Qi Liu on 2020-08-13.
//  Copyright © 2020 qi. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    
    let persistentContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { (storeDescription, err) in
            guard err == nil else {
                fatalError(err.debugDescription)
            }
            completion?()
        }
    }
}
