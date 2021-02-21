//
//  CoreDataStack.swift
//  Homework6
//
//  Created by spezza on 21.02.2021.
//

import CoreData

class CoreDataStack {
    
    static let shared: CoreDataStack = CoreDataStack()
    
    private init() {
    }
    
    lazy var viewContext: NSManagedObjectContext = {
        let result = container.viewContext
        return result
    }()
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Memes Library")
        
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]

        container.loadPersistentStores(completionHandler: { (_, error) in
            container.viewContext.automaticallyMergesChangesFromParent = true
            container.viewContext.mergePolicy = NSMergePolicy(merge: NSMergePolicyType.mergeByPropertyObjectTrumpMergePolicyType)

            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func save () {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                viewContext.rollback()
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
