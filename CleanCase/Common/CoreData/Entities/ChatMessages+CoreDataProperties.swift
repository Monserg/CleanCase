//
//  ChatMessages+CoreDataProperties.swift
//  CleanCase
//
//  Created by Denis Miltsine on 20/03/2018.
//  Copyright © 2018 msm72. All rights reserved.
//
//

import Foundation
import CoreData


extension ChatMessages {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChatMessages> {
        return NSFetchRequest<ChatMessages>(entityName: "ChatMessages")
    }

    @NSManaged public var text: String
    @NSManaged public var created_date: String
    @NSManaged public var laundry_id: Int32

}
