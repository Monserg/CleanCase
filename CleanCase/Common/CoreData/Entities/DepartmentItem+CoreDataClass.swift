//
//  DepartmentItem+CoreDataClass.swift
//  CleanCase
//
//  Created by msm72 on 06.02.2018.
//  Copyright © 2018 msm72. All rights reserved.
//
//

import Foundation
import CoreData

@objc(DepartmentItem)
public class DepartmentItem: NSManagedObject {
    // MARK: - Class Initialization
    deinit {
        Logger.log(message: "Success", event: .Severe)
    }
}
