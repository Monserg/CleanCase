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

        case "iD":
            if let cityModel = self as? ResponseAPICity {
                return cityModel.ID
            }
                
            else if let laundryModel = self as? ResponseAPILaundryInfo {
                return laundryModel.ID
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
            
        case "telephone":
            return (self as! ResponseAPILaundryInfo).Telephone
            
        case "fromDate":
            return (self as! ResponseAPICollectionDate).FromDate
            
        case "toDate":
            return (self as! ResponseAPICollectionDate).ToDate
            
        case "laundryId":
            return (self as! ResponseAPICollectionDate).LaundryId
            
        case "remarks":
            return (self as! ResponseAPICollectionDate).Remarks
            
        case "type":
            return (self as! ResponseAPICollectionDate).Type
            
        case "weekDay":
            return (self as! ResponseAPICollectionDate).WeekDay
            
        default:
            fatalError("Wrong property name")
        }
        
        return nil
    }
}
