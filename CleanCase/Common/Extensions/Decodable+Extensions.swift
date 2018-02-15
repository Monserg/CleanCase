//
//  Decodable+Extensions.swift
//  CleanCase
//
//  Created by msm72 on 05.02.2018.
//  Copyright © 2018 msm72. All rights reserved.
//

import UIKit

extension Decodable {
    func propertyNames() -> [String] {
        return Mirror(reflecting: self).children.flatMap { $0.label }
    }
    
    func valueByProperty(name: String) -> Any? {
        switch name {
        case "getVerResult":
            return (self as! ResponseAPIVersion).GetVerResult

        case "cityName":
            if let cityModel = self as? ResponseAPICity {
                return cityModel.CityName
            }
            
            else if let laundryModel = self as? ResponseAPILaundryInfo {
                return laundryModel.CityName
            }

            else if let collectionDateModel = self as? ResponseAPICollectionDate {
                return collectionDateModel.CityName
            }

            else if let deliveryDateModel = self as? ResponseAPIDeliveryDate {
                return deliveryDateModel.CityName
            }

        case "iD":
            if let cityModel = self as? ResponseAPICity {
                return cityModel.ID
            }
                
            else if let laundryModel = self as? ResponseAPILaundryInfo {
                return laundryModel.ID
            }

            else if let orderItemModel = self as? ResponseAPIOrderItem {
                return orderItemModel.ID
            }

        case "id":
            if let departmentModel = self as? ResponseAPIDepartment {
                return departmentModel.Id
            }
                
            else if let departmentItemModel = self as? ResponseAPIDepartmentItem {
                return departmentItemModel.Id
            }

        case "cityID":
            return (self as! ResponseAPILaundryInfo).CityID
            
        case "addressLine":
            return (self as! ResponseAPILaundryInfo).AddressLine

        case "businessId":
            return (self as! ResponseAPILaundryInfo).BusinessId
            
        case "header":
            return (self as! ResponseAPILaundryInfo).Header
            
        case "name":
            if let laundryInfoModel = self as? ResponseAPILaundryInfo {
                return laundryInfoModel.Name
            }

            else if let collectionDateModel = self as? ResponseAPICollectionDate {
                return collectionDateModel.Name
            }

            else if let deliveryDateModel = self as? ResponseAPIDeliveryDate {
                return deliveryDateModel.Name
            }
            
            else if let departmentItemModel = self as? ResponseAPIDepartmentItem {
                return departmentItemModel.Name
            }
            
            else if let orderItemModel = self as? ResponseAPIOrderItem {
                return orderItemModel.Name
            }


        case "telephone":
            return (self as! ResponseAPILaundryInfo).Telephone
            
        case "fromDate":
            if let collectionDateModel = self as? ResponseAPICollectionDate {
                return collectionDateModel.FromDate
            }
                
            else if let deliveryDateModel = self as? ResponseAPIDeliveryDate {
                return deliveryDateModel.FromDate
            }
            
        case "toDate":
            if let collectionDateModel = self as? ResponseAPICollectionDate {
                return collectionDateModel.ToDate
            }
                
            else if let deliveryDateModel = self as? ResponseAPIDeliveryDate {
                return deliveryDateModel.ToDate
            }
            
        case "laundryId":
            if let collectionDateModel = self as? ResponseAPICollectionDate {
                return collectionDateModel.LaundryId
            }
                
            else if let deliveryDateModel = self as? ResponseAPIDeliveryDate {
                return deliveryDateModel.LaundryId
            }
            
            else if let departmentModel = self as? ResponseAPIDepartment {
                return departmentModel.LaundryId
            }
            
        case "remarks":
            if let collectionDateModel = self as? ResponseAPICollectionDate {
                return collectionDateModel.Remarks
            }
                
            else if let deliveryDateModel = self as? ResponseAPIDeliveryDate {
                return deliveryDateModel.Remarks
            }
            
        case "type":
            if let collectionDateModel = self as? ResponseAPICollectionDate {
                return collectionDateModel.Type
            }
                
            else if let deliveryDateModel = self as? ResponseAPIDeliveryDate {
                return deliveryDateModel.Type
            }
            
        case "weekDay":
            if let collectionDateModel = self as? ResponseAPICollectionDate {
                return collectionDateModel.WeekDay
            }
                
            else if let deliveryDateModel = self as? ResponseAPIDeliveryDate {
                return deliveryDateModel.WeekDay
            }
            
        case "departmentId":
            if let departmentModel = self as? ResponseAPIDepartment {
                return departmentModel.DepartmentId
            }
                
            else if let departmentItemModel = self as? ResponseAPIDepartmentItem {
                return departmentItemModel.DepartmentId
            }
            
        case "departmentID":
            if let orderItemModel = self as? ResponseAPIOrderItem {
                return orderItemModel.DepartmentID
            }

        case "departmentItemId":
            if let departmentItemModel = self as? ResponseAPIDepartmentItem {
                return departmentItemModel.DepartmentItemId
            }
            
        case "departmentItemID":
            if let orderItemModel = self as? ResponseAPIOrderItem {
                return orderItemModel.DepartmentItemID
            }
            
        case "departmentName":
            if let departmentModel = self as? ResponseAPIDepartment {
                return departmentModel.DepartmentName
            }
                
            else if let departmentItemModel = self as? ResponseAPIDepartmentItem {
                return departmentItemModel.DepartmentName
            }
            
        case "description":
            if let departmentModel = self as? ResponseAPIDepartment {
                return departmentModel.Description
            }
                
            else if let departmentItemModel = self as? ResponseAPIDepartmentItem {
                return departmentItemModel.Description
            }
            
        case "price":
            if let departmentItemModel = self as? ResponseAPIDepartmentItem {
                return departmentItemModel.Price
            }

            else if let orderItemModel = self as? ResponseAPIOrderItem {
                return orderItemModel.Price
            }

        case "height":
            if let orderItemModel = self as? ResponseAPIOrderItem {
                return orderItemModel.Height
            }

        case "orderID":
            if let orderItemModel = self as? ResponseAPIOrderItem {
                return orderItemModel.OrderID
            }

        case "qty":
            if let orderItemModel = self as? ResponseAPIOrderItem {
                return orderItemModel.Qty
            }
            
        case "width":
            if let orderItemModel = self as? ResponseAPIOrderItem {
                return orderItemModel.Width
            }
            
        case "status":
            if let orderItemModel = self as? ResponseAPIOrderItem {
                return orderItemModel.Status
            }

        default:
            fatalError("Wrong property name")
        }
        
        return nil
    }
}
