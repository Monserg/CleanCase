//
//  CoreDataManager.swift
//  CleanCase
//
//  Created by msm72 on 02.02.2018.
//  Copyright © 2018 msm72. All rights reserved.
//

import CoreData
import Foundation

class CoreDataManager {
    // MARK: - Properties. CoreDate Stack
    var modelName: String
    var sqliteName: String
    var options: NSDictionary?    

    var description: String {
        return "context: \(managedObjectContext)\n" + "modelName: \(modelName)" +
            //        "model: \(model.entityVersionHashesByName)\n" +
            //        "coordinator: \(coordinator)\n" +
        "storeURL: \(applicationDocumentsDirectory)\n"
        //        "store: \(store)"
    }
    
    lazy var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return urls[urls.count - 1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: "momd")!
        
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator     =   NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url             =   self.applicationDocumentsDirectory.appendingPathComponent(self.sqliteName + ".sqlite")
        var failureReason   =   NSLocalizedString("CoreData saved error".localized(), comment: "")
        
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: self.options as! [AnyHashable: Any]?)
        } catch {
            var dict                                =   [String: AnyObject]()
            dict[NSLocalizedDescriptionKey]         =   NSLocalizedString("CoreData init error".localized(), comment: "") as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey]  =   failureReason as AnyObject?
            dict[NSUnderlyingErrorKey]              =   error as NSError
            let wrappedError                        =   NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        return managedObjectContext
    }()

    
    // MARK: - Class Initialization
    static let instance = CoreDataManager(modelName:  "CleanCaseModel",
                                          sqliteName: "CleanCaseModel",
                                          options:    [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true])
    
    private init(modelName: String, sqliteName: String, options: NSDictionary? = nil) {
        self.modelName      =   modelName
        self.sqliteName     =   sqliteName
        self.options        =   options
    }
    
    
    // MARK: - Class Functions
    // Save context
    func contextSave() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    
    // MARK: - CRUD
    // Create
    
    
    // Read
    func readEntity(withName name: String, andPredicateParameters predicate: NSPredicate?) -> NSManagedObject? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        
        if predicate != nil {
            fetchRequest.predicate = predicate!
        }

        do {
            return try CoreDataManager.instance.managedObjectContext.fetch(fetchRequest).first as? NSManagedObject
        } catch {
            print(error)
            
            return nil
        }
    }
    
    func entitiesRead(withName name: String, andPredicateParameters predicate: NSPredicate?) -> [NSManagedObject]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)

        if predicate != nil {
            fetchRequest.predicate = predicate!
        }

        do {
            return try CoreDataManager.instance.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
        } catch {
            print(error)
            
            return nil
        }
    }
    
    // Update
    func updateEntity(_ property: EntityUpdateTuple) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: property.name)
        
        if let predicate = property.predicate {
            fetchRequest.predicate = predicate
        }
        
        var entity = readEntity(withName: property.name, andPredicateParameters: property.predicate)
        
        if entity == nil {
            entity = self.createEntity(property.name)
        }
        
        for dict in property.values {
            entity!.setValue(dict.value, forKey: dict.key)
        }

        self.contextSave()
    }

    // Create
    fileprivate func createEntity(_ name: String) -> NSManagedObject {
        return NSEntityDescription.insertNewObject(forEntityName: name, into: managedObjectContext)
    }
}
