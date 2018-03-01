//
//  OrderItem+CoreDataClass.swift
//  CleanCase
//
//  Created by msm72 on 13.02.2018.
//  Copyright © 2018 msm72. All rights reserved.
//
//

import Foundation
import CoreData

@objc(OrderItem)
public class OrderItem: NSManagedObject {
    // MARK: - Class Functions
    func updateEntity(fromResponse responseAPI: ResponseAPIOrderItem) {
        self.iD                 =   responseAPI.ID
        self.name               =   responseAPI.Name
        self.orderID            =   responseAPI.OrderID
        self.price              =   responseAPI.Price
        self.qty                =   responseAPI.Qty
        self.departmentID       =   responseAPI.DepartmentID
        self.departmentItemID   =   responseAPI.DepartmentItemID
        self.height             =   responseAPI.Height
        self.width              =   responseAPI.Width
    }
}
