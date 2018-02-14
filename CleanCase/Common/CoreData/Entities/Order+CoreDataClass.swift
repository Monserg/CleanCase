//
//  Order+CoreDataClass.swift
//  CleanCase
//
//  Created by msm72 on 13.02.2018.
//  Copyright © 2018 msm72. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Order)
public class Order: NSManagedObject {
    // MARK: - Class Functions
    func updateEntity(fromJSON json: [String: Any]) {
        if let orderEntity = CoreDataManager.instance.createEntity("Order") as? Order {
            orderEntity.price                   =   json["Price"] as! Float
            orderEntity.orderID                 =   Int16(json["OrderID"] as! String)!
            orderEntity.clientID                =   json["ClientId"] as! Int16
            orderEntity.remarks                 =   json["Remarks"] as? String
            orderEntity.address1                =   json["Address1"] as? String
            orderEntity.orderStatus             =   Int16(json["OrderStatus"] as! Int)
            orderEntity.createdDate             =   json["CreatedDate"] as! String
            orderEntity.collectionTo            =   json["CollectionTo"] as! String
            orderEntity.collectionFrom          =   json["CollectionFrom"] as! String
            orderEntity.cleaningInstructions    =   json["CleaningInstructions"] as? String

            CoreDataManager.instance.contextSave()
        }
    }
}
