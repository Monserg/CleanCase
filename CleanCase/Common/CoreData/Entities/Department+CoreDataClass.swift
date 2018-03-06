//
//  Department+CoreDataClass.swift
//  CleanCase
//
//  Created by msm72 on 06.02.2018.
//  Copyright © 2018 msm72. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Department)
public class Department: NSManagedObject {
    // MARK: - Class Initialization
    deinit {
        Logger.log(message: "Success", event: .Severe)
    }
    
    
    // MARK: - Class Functions
    func updateEntity(fromResponse responseAPI: ResponseAPIDepartment) {
        self.departmentId       =   responseAPI.DepartmentId
        self.departmentName     =   responseAPI.DepartmentName
        self.descriptionItem    =   responseAPI.Description
        self.id                 =   responseAPI.Id
        self.laundryId          =   responseAPI.LaundryId
        
        self.items = []

        CoreDataManager.instance.deleteEntities(withName: "DepartmentItem",
                                                andPredicateParameters: NSPredicate.init(format: "departmentId == \(self.id)"),
                                                completion: { success in })
    }
}
