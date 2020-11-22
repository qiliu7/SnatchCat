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
    
    static var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SnatchCat")
        container.loadPersistentStores { (storeDescription, err) in
            if let err = err as NSError? {
                fatalError("unresolved error \(err), \(err.userInfo)")
            }
        }
        return container
    }()
    
    static func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
