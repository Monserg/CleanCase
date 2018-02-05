//
//  Laundry+CoreDataClass.swift
//  CleanCase
//
//  Created by msm72 on 05.02.2018.
//  Copyright © 2018 msm72. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Laundry)
public class Laundry: NSManagedObject {
    // MARK: - Properties
    class var name: String {
        get {
            if let laundryEntity = CoreDataManager.instance.readEntity(withName: "Laundry", andPredicateParameters: nil) as? Laundry {
                return laundryEntity.name
            }
            
            return "My Laundry".localized()
        }
    }

    class var phoneNumber: String? {
        get {
            if let laundryEntity = CoreDataManager.instance.readEntity(withName: "Laundry", andPredicateParameters: nil) as? Laundry,
                let phone = laundryEntity.telephone {
                return phone
            }
            
            return nil
        }
    }

    class var codeID: Int16 {
        get {
            if let laundryEntity = CoreDataManager.instance.readEntity(withName: "Laundry", andPredicateParameters: nil) as? Laundry {
                return laundryEntity.iD
            }
            
            return 0
        }
    }
}
