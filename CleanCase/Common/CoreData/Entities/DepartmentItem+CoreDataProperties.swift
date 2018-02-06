//
//  DepartmentItem+CoreDataProperties.swift
//  CleanCase
//
//  Created by msm72 on 06.02.2018.
//  Copyright © 2018 msm72. All rights reserved.
//
//

import Foundation
import CoreData


extension DepartmentItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DepartmentItem> {
        return NSFetchRequest<DepartmentItem>(entityName: "DepartmentItem")
    }

    @NSManaged public var departmentId: Int16
    @NSManaged public var departmentItemId: Int16
    @NSManaged public var departmentName: String
    @NSManaged public var id: Int16
    @NSManaged public var name: String
    @NSManaged public var price: Float
    @NSManaged public var descriptionItem: String?
    @NSManaged public var department: Department?

}
