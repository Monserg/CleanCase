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

enum OrderStatus: Int16 {
    case None                   =   0
    case Opened                 =   1
    case Closed                 =   2
    case Ready                  =   3
    case InWayToLaundry         =   4
    case Supplied               =   5
    case Cancel                 =   6
    case InProcess              =   7
    case InWayToClient          =   8
    case PackagesInOffice       =   9
    case LockerOrderChanged     =   10
    case Paid                   =   11
    case RequestForPaid         =   12
    
    var name: String {
        get {
            return String(describing: self)
        }
    }
    
    // Example
    //    let state = OrderStatus.Closed
    //    print(state.name)
}

@objc(Order)
public class Order: NSManagedObject {
    // MARK: - Properties
    class var last: Order? {
        get {
            return (CoreDataManager.instance.readEntities(withName: "Order",
                                                          withPredicateParameters: NSPredicate.init(format: "orderStatus != 2 AND orderStatus != 6"),
                                                          andSortDescriptor: NSSortDescriptor.init(key: "orderID", ascending: false))?.first) as? Order
        }
    }
    
    
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
