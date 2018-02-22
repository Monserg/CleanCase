//
//  Token+CoreDataClass.swift
//  CleanCase
//
//  Created by msm72 on 22.02.2018.
//  Copyright © 2018 msm72. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Token)
public class Token: NSManagedObject {
    // MARK: - Properties
    class var current: Token? {
        get {
            return (CoreDataManager.instance.readEntity(withName: "Token", andPredicateParameters: nil)) as? Token
        }
    }
}
