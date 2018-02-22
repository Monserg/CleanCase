//
//  PersonalData+CoreDataClass.swift
//  CleanCase
//
//  Created by msm72 on 12.02.2018.
//  Copyright © 2018 msm72. All rights reserved.
//
//

import Foundation
import CoreData

@objc(PersonalData)
public class PersonalData: NSManagedObject {
    // MARK: - Properties
    class var current: PersonalData? {
        get {
            return (CoreDataManager.instance.readEntity(withName: "PersonalData", andPredicateParameters: nil)) as? PersonalData
        }
    }
    

    // MARK: - Class Functions
    func updateEntity(fromJSON json: [String: Any]) {
        self.addressLine1    =   json["AddressLine1"] as! String
        self.addressLine2    =   json["AddressLine2"] as? String
        self.adv             =   json["Adv"] as! String
        self.cardCVV         =   json["CardCVV"] as? String
        self.cardExpired     =   json["CardExpired"] as? String
        self.cardNumber      =   json["CardNumber"] as? String
        self.cityId          =   json["CityId"] as! String
        self.clientId        =   json["ClientId"] as! Int16
        self.email           =   json["Email"] as! String
        self.firstName       =   json["FirstName"] as! String
        self.lastName        =   json["LastName"] as! String
        self.laundryId       =   json["LaundryId"] as! Int16
        self.mobilePhone     =   json["MobilePhone"] as! String
        self.postCode        =   json["PostCode"] as? String
        
        CoreDataManager.instance.contextSave()
    }
}
