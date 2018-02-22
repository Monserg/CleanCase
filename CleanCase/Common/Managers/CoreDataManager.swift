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
        }
        
        catch {
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
            }
            
            catch {
                let nserror = error as NSError
                
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    
    // MARK: - CRUD
    // Create
    func createEntity(_ name: String) -> NSManagedObject {
        return NSEntityDescription.insertNewObject(forEntityName: name, into: managedObjectContext)
    }

    
    // Read
    func readEntity(withName name: String, andPredicateParameters predicate: NSPredicate?) -> NSManagedObject? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        
        if predicate != nil {
            fetchRequest.predicate = predicate!
        }

        do {
            return try self.managedObjectContext.fetch(fetchRequest).first as? NSManagedObject
        }
        
        catch {
            print(error)
            
            return nil
        }
    }
    
    func readEntities(withName name: String, withPredicateParameters predicate: NSPredicate?, andSortDescriptor sortDescriptor: NSSortDescriptor?) -> [NSManagedObject]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)

        if predicate != nil {
            fetchRequest.predicate = predicate!
        }
        
        if sortDescriptor != nil {
            fetchRequest.sortDescriptors = [ sortDescriptor! ]
            fetchRequest.fetchLimit = 20
        }

        do {
            return try self.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
        }
        
        catch {
            print(error)
            
            return nil
        }
    }
    
   
    // Update
    func updateEntity(withData data: EntityUpdateTuple) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: data.name)
        
        if let predicate = data.predicate {
            fetchRequest.predicate = predicate
        }
        
        var entity = readEntity(withName: data.name, andPredicateParameters: data.predicate)
        
        if entity == nil {
            entity = self.createEntity(data.name)
        }
        
        for propertyName in data.model.propertyNames() {
            if propertyName == "Description" {
                entity!.setValue(data.model.valueByProperty(name: propertyName.lowercaseFirst()), forKey: "descriptionItem")
            }
            
            else if propertyName == "Items" {
                if let model = data.model as? ResponseAPIDepartment, let items = model.Items, items.count > 0 {
                    let department = readEntity(withName:                   "Department",
                                                andPredicateParameters:     NSPredicate.init(format: "departmentId = \(model.DepartmentId)")) as! Department

                    for item in items {
                        let predicate = NSPredicate.init(format: "departmentId == \(item.DepartmentId) AND departmentItemId == \(item.DepartmentItemId)")
                        
                        self.updateEntity(withData: EntityUpdateTuple(name:             "DepartmentItem",
                                                                      predicate:        predicate,
                                                                      model:            item))
                        
                        department.addToItems(self.readEntity(withName:                 "DepartmentItem",
                                                              andPredicateParameters:   predicate) as! DepartmentItem)
                    }
                }
            }
                
            else if propertyName == "Status" {
                print("status...")
            }
                
            else {
                entity!.setValue(data.model.valueByProperty(name: propertyName.lowercaseFirst()), forKey: propertyName.lowercaseFirst())
            }
        }

        self.contextSave()
    }
    
    
    // Delete
    
}
