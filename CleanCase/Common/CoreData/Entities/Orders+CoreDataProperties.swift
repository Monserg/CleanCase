//
//  Orders+CoreDataProperties.swift
//  CleanCase
//
//  Created by msm72 on 12.02.2018.
//  Copyright © 2018 msm72. All rights reserved.
//
//

import Foundation
import CoreData


extension Orders {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Orders> {
        return NSFetchRequest<Orders>(entityName: "Orders")
    }

    @NSManaged public var createdDate: String
    @NSManaged public var orderStatus: Int16
    @NSManaged public var orderID: Int16
    @NSManaged public var price: Float
    @NSManaged public var discount: Float
    @NSManaged public var collectionFrom: String
    @NSManaged public var collectionTo: String
    @NSManaged public var deliveryFrom: String?
    @NSManaged public var deliveryTo: String?
    @NSManaged public var address1: String?
    @NSManaged public var address2: String?
    @NSManaged public var cleaningInstructions: String?
    @NSManaged public var deliveryNotes: String?

}
