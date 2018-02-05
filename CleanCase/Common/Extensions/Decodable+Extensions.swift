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
    
    func valueByProperty(name: String) -> Any {
        switch name {
        case "getVerResult":
            return (self as! ResponseAPIVersion).GetVerResult

        case "cityName":
            return (self as! ResponseAPICity).CityName
        
        case "iD":
            return (self as! ResponseAPICity).ID
        
        default:
            fatalError("Wrong property name")
        }
    }
}
