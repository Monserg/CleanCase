//
//  SignInShowInteractor.swift
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
protocol SignInShowBusinessLogic {
    func fetchCities(withRequestModel requestModel: SignInShowModels.City.RequestModel)
}

protocol SignInShowDataStore {
     var cities: [City]! { get set }
}

class SignInShowInteractor: ShareInteractor, SignInShowBusinessLogic, SignInShowDataStore {
    // MARK: - Properties
    var presenter: SignInShowPresentationLogic?
    var worker: SignInShowWorker?
    
    // SignInShowDataStore protocol implementation
    var cities: [City]! = [City]()
    
    
    // MARK: - Business logic implementation
    func fetchCities(withRequestModel requestModel: SignInShowModels.City.RequestModel) {
        worker = SignInShowWorker()
        
        // API: Fetch request data
        self.appDependency.restAPIManager.fetchRequest(withRequestType: .getCitiesList(), andResponseType: ResponseAPICities.self, completionHandler: { [unowned self] responseAPI in
            if let result = responseAPI.model as? ResponseAPICities {
                // TODO: - SAVE TO COREDATA & CITIES
                print(result)
            }
            
            let responseModel = SignInShowModels.City.ResponseModel()
            self.presenter?.presentCities(fromResponseModel: responseModel)
        })
    }
}
