//
//  Version+CoreDataClass.swift
//  CleanCase
//
//  Created by msm72 on 02.02.2018.
//  Copyright © 2018 msm72. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Version)
public class Version: NSManagedObject {
    // MARK: - Properties
    class var currentVersion: Int16 {
        get {
            if let versionEntity = CoreDataManager.instance.readEntity(withName: "Version", andPredicateParameters: nil) as? Version {
                return versionEntity.getVerResult
            }
            
            return 0
        }
    }
}
