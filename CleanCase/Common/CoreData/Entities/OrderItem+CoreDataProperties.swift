//
//  OrderItem+CoreDataProperties.swift
//  CleanCase
//
//  Created by msm72 on 13.02.2018.
//  Copyright © 2018 msm72. All rights reserved.
//
//

import Foundation
import CoreData


extension OrderItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OrderItem> {
        return NSFetchRequest<OrderItem>(entityName: "OrderItem")
    }

    @NSManaged public var orderID: Int16
    @NSManaged public var itemID: Int16
    @NSManaged public var price: Float
    @NSManaged public var name: String?
    @NSManaged public var quantity: Int16
    @NSManaged public var order: Order?

}
