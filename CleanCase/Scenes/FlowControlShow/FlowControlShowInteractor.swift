//
//  FlowControlShowInteractor.swift
//  CleanCase
//
//  Created by msm72 on 02.02.2018.
//  Copyright (c) 2018 msm72. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

// MARK: - Business Logic protocols
protocol FlowControlShowBusinessLogic {
    func fetchAppWorkingVersion(withRequestModel requestModel: FlowControlShowModels.Version.RequestModel)
}

protocol FlowControlShowDataStore {
}

class FlowControlShowInteractor: ShareInteractor, FlowControlShowBusinessLogic, FlowControlShowDataStore {
    // MARK: - Properties
    var presenter: FlowControlShowPresentationLogic?
    
    var isEqual: Bool = true
    
    
    // MARK: - Business logic implementation
    func fetchAppWorkingVersion(withRequestModel requestModel: FlowControlShowModels.Version.RequestModel) {
        // API: Fetch request data
        self.appDependency.restAPIManager.fetchRequest(withRequestType: .getCurrentAppWorkingVersion(nil, false), andResponseType: ResponseAPIVersion.self, completionHandler: { [unowned self] responseAPI in
            if let model = responseAPI.model as? ResponseAPIVersion {
                Logger.log(message: "Check App Working Version: version = \(model.GetVerResult), build = \(Version.currentVersion)", event: .Verbose)
                self.isEqual = Version.currentVersion == model.GetVerResult
            }
            
            let responseModel = FlowControlShowModels.Version.ResponseModel(isEqual: self.isEqual)
            self.presenter?.presentAppWorkingVersion(fromResponseModel: responseModel)
        })
    }
}
