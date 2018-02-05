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
            return (self as! ResponseAPILaundryInfo).Name
            
        case "telephone":
            return (self as! ResponseAPILaundryInfo).Telephone
            
        default:
            fatalError("Wrong property name")
        }
        
        return nil
    }
}
