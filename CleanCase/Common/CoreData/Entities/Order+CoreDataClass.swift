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
    class var firstToChangeStatus: Order? {
        get {
            return (CoreDataManager.instance.readEntities(withName:                 "Order",
                                                          withPredicateParameters:  NSPredicate.init(format: "orderStatus != 2 AND orderStatus != 6 AND deliveryFrom == NULL AND deliveryTo == NULL"),
                                                          andSortDescriptor:        NSSortDescriptor.init(key: "orderID", ascending: false))?.first) as? Order
        }
    }

    class var firstToDelivery: Order? {
        get {
            return (CoreDataManager.instance.readEntities(withName:                 "Order",
                                                          withPredicateParameters:  NSPredicate.init(format: "orderStatus == 3 AND deliveryFrom == NULL AND deliveryTo == NULL"),
                                                          andSortDescriptor:        NSSortDescriptor.init(key: "orderID", ascending: false))?.first) as? Order
        }
    }

    
    // MARK: - Class Functions
    func updateEntity(fromJSON json: [String: Any]) {
            self.price                   =   json["Price"] as! Float
            self.orderID                 =   Int16(json["OrderID"] as! String)!
            self.clientID                =   json["ClientId"] as! Int16
            self.remarks                 =   json["Remarks"] as? String
            self.address1                =   json["Address1"] as? String
            self.orderStatus             =   Int16(json["OrderStatus"] as! Int)
            self.createdDate             =   json["CreatedDate"] as! String
            self.collectionTo            =   json["CollectionTo"] as! String
            self.collectionFrom          =   json["CollectionFrom"] as! String
            self.cleaningInstructions    =   json["CleaningInstructions"] as? String
    }
    
    func getItems() {
        // API
        RestAPIManager().fetchRequest(withRequestType: RequestType.getOrderItemsList([ "order_id": self.orderID ], false), andResponseType: ResponseAPIOrderItemsResult.self, completionHandler: { [unowned self] responseAPI in
            if let result = responseAPI.model as? ResponseAPIOrderItemsResult, let orderItemsList = result.GetItemsResult, orderItemsList.count > 0 {
                // Remote all items for current Order
                self.items = nil
                
                for orderItem in orderItemsList {
                    let predicate = NSPredicate.init(format: "iD == \(orderItem.ID) AND orderID == \(orderItem.OrderID) AND departmentID == \(orderItem.DepartmentID) AND departmentItemID == \(orderItem.DepartmentItemID)")
                    
                    CoreDataManager.instance.updateEntity(withData: EntityUpdateTuple(name:         "OrderItem",
                                                                                      predicate:    predicate,
                                                                                      model:        orderItem))
                    
                    self.addToItems(CoreDataManager.instance.readEntity(withName:                   "OrderItem",
                                                                        andPredicateParameters:     predicate) as! OrderItem)
                }
            }
            
            self.save()
        })
    }
}
