//
//  Laundry+CoreDataProperties.swift
//  CleanCase
//
//  Created by msm72 on 05.02.2018.
//  Copyright © 2018 msm72. All rights reserved.
//
//

import Foundation
import CoreData


extension Laundry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Laundry> {
        return NSFetchRequest<Laundry>(entityName: "Laundry")
    }

    @NSManaged public var addressLine: String?
    @NSManaged public var businessId: String?
    @NSManaged public var cityID: Int16
    @NSManaged public var cityName: String
    @NSManaged public var header: String?
    @NSManaged public var iD: Int16
    @NSManaged public var name: String
    @NSManaged public var telephone: String?

}
