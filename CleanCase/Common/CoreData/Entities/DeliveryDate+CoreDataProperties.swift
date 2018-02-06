//
//  DeliveryDate+CoreDataProperties.swift
//  CleanCase
//
//  Created by msm72 on 06.02.2018.
//  Copyright © 2018 msm72. All rights reserved.
//
//

import Foundation
import CoreData


extension DeliveryDate {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DeliveryDate> {
        return NSFetchRequest<DeliveryDate>(entityName: "DeliveryDate")
    }

    @NSManaged public var cityName: String?
    @NSManaged public var fromDate: String
    @NSManaged public var laundryId: Int16
    @NSManaged public var name: String?
    @NSManaged public var remarks: String?
    @NSManaged public var toDate: String
    @NSManaged public var type: Int16
    @NSManaged public var weekDay: Int16

}
