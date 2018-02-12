//
//  PersonalData+CoreDataProperties.swift
//  CleanCase
//
//  Created by msm72 on 12.02.2018.
//  Copyright © 2018 msm72. All rights reserved.
//
//

import Foundation
import CoreData


extension PersonalData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PersonalData> {
        return NSFetchRequest<PersonalData>(entityName: "PersonalData")
    }

    @NSManaged public var addressLine1: String?
    @NSManaged public var addressLine2: String?
    @NSManaged public var adv: String?
    @NSManaged public var cardCVV: String?
    @NSManaged public var cardExpired: String?
    @NSManaged public var cardNumber: String?
    @NSManaged public var cityId: String?
    @NSManaged public var clientId: Int16
    @NSManaged public var email: String?
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var laundryId: Int16
    @NSManaged public var mobilePhone: String?
    @NSManaged public var postCode: String?

}
