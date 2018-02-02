//
//  ShareInteractor.swift
//  CleanCase
//
//  Created by msm72 on 02.02.2018.
//  Copyright © 2018 msm72. All rights reserved.
//

import Foundation

struct AppDependency: HasRestAPIManager, HasCoreDataManager {
    let restAPIManager      =   RestAPIManager()
    let coreDataManager     =   CoreDataManager.instance
}

class ShareInteractor {
    // Dependency Injection
    let appDependency: AppDependency

    
    // MARK: - Class Initialization
    init(_ appDependency: AppDependency) {
        self.appDependency = appDependency
    }
}
