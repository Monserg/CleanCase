//
//  Tested+CoreDataProperties.swift
//  CleanCase
//
//  Created by msm72 on 20.03.2018.
//  Copyright © 2018 msm72. All rights reserved.
//
//

import Foundation
import CoreData


extension Tested {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tested> {
        return NSFetchRequest<Tested>(entityName: "Tested")
    }

    @NSManaged public var id: Int16
    @NSManaged public var name: String?

}
