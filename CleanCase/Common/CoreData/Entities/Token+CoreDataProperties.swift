//
//  Token+CoreDataProperties.swift
//  CleanCase
//
//  Created by msm72 on 22.02.2018.
//  Copyright © 2018 msm72. All rights reserved.
//
//

import Foundation
import CoreData


extension Token {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Token> {
        return NSFetchRequest<Token>(entityName: "Token")
    }

    @NSManaged public var device: String?
    @NSManaged public var firebase: String?

}
