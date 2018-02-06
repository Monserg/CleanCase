//
//  Department+CoreDataProperties.swift
//  CleanCase
//
//  Created by msm72 on 06.02.2018.
//  Copyright © 2018 msm72. All rights reserved.
//
//

import Foundation
import CoreData


extension Department {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Department> {
        return NSFetchRequest<Department>(entityName: "Department")
    }

    @NSManaged public var departmentId: Int16
    @NSManaged public var departmentName: String
    @NSManaged public var descriptionItem: String?
    @NSManaged public var id: Int16
    @NSManaged public var laundryId: Int16
    @NSManaged public var items: NSSet?

}

// MARK: Generated accessors for items
extension Department {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: DepartmentItem)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: DepartmentItem)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}
