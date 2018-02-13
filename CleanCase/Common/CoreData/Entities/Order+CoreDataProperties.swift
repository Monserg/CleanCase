//
//  Order+CoreDataProperties.swift
//  CleanCase
//
//  Created by msm72 on 13.02.2018.
//  Copyright © 2018 msm72. All rights reserved.
//
//

import Foundation
import CoreData


extension Order {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Order> {
        return NSFetchRequest<Order>(entityName: "Order")
    }

    @NSManaged public var address1: String?
    @NSManaged public var address2: String?
    @NSManaged public var cleaningInstructions: String?
    @NSManaged public var collectionFrom: String
    @NSManaged public var collectionTo: String
    @NSManaged public var createdDate: String
    @NSManaged public var deliveryFrom: String?
    @NSManaged public var deliveryNotes: String?
    @NSManaged public var deliveryTo: String?
    @NSManaged public var discount: Float
    @NSManaged public var orderID: Int16
    @NSManaged public var orderStatus: Int16
    @NSManaged public var price: Float
    @NSManaged public var items: NSSet?

}

// MARK: Generated accessors for items
extension Order {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: OrderItems)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: OrderItems)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}
