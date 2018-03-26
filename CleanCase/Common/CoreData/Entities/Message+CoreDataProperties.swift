//
//  Message+CoreDataProperties.swift
//  CleanCase
//
//  Created by msm72 on 25.03.2018.
//  Copyright © 2018 msm72. All rights reserved.
//
//

import Foundation
import CoreData


extension Message {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message")
    }

    @NSManaged public var type: Int16
    @NSManaged public var text: String
    @NSManaged public var date: String
    @NSManaged public var codeID: Int16

}
