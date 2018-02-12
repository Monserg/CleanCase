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
        var personalDataEntity = CoreDataManager.instance.readEntity(withName: "PersonalData",
                                                                     andPredicateParameters: NSPredicate.init(format: "clientId == \(json["ClientId"] as! Int16)")) as? PersonalData
        if personalDataEntity == nil {
            personalDataEntity = CoreDataManager.instance.createEntity("PersonalData") as? PersonalData
        }

        personalDataEntity!.addressLine1    =   json["AddressLine1"] as! String
        personalDataEntity!.addressLine2    =   json["AddressLine2"] as? String
        personalDataEntity!.adv             =   json["Adv"] as! String
        personalDataEntity!.cardCVV         =   json["CardCVV"] as? String
        personalDataEntity!.cardExpired     =   json["CardExpired"] as? String
        personalDataEntity!.cardNumber      =   json["CardNumber"] as? String
        personalDataEntity!.cityId          =   json["CityId"] as! String
        personalDataEntity!.clientId        =   json["ClientId"] as! Int16
        personalDataEntity!.email           =   json["Email"] as! String
        personalDataEntity!.firstName       =   json["FirstName"] as! String
        personalDataEntity!.lastName        =   json["LastName"] as! String
        personalDataEntity!.laundryId       =   json["LaundryId"] as! Int16
        personalDataEntity!.mobilePhone     =   json["MobilePhone"] as! String
        personalDataEntity!.postCode        =   json["PostCode"] as? String
        
        CoreDataManager.instance.contextSave()
    }
}
