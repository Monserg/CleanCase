//
//  OrderItem+CoreDataProperties.swift
//  CleanCase
//
//  Created by msm72 on 15.02.2018.
//  Copyright © 2018 msm72. All rights reserved.
//
//

import Foundation
import CoreData


extension OrderItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OrderItem> {
        return NSFetchRequest<OrderItem>(entityName: "OrderItem")
    }

    @NSManaged public var iD: Int16
    @NSManaged public var name: String
    @NSManaged public var orderID: Int16
    @NSManaged public var price: Float
    @NSManaged public var qty: Int16
    @NSManaged public var departmentID: Int16
    @NSManaged public var departmentItemID: Int16
    @NSManaged public var height: Float
    @NSManaged public var width: Float

    @NSManaged public var order: Order?

}
