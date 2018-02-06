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
    func saveSelectedCityID(_ value: String)
    func fetchCities(withRequestModel requestModel: SignInShowModels.City.RequestModel)
    func fetchLaundry(withRequestModel requestModel: SignInShowModels.Laundry.RequestModel)
    func fetchDeliveryDates(withRequestModel requestModel: SignInShowModels.Date.RequestModel)
    func fetchCollectionDates(withRequestModel requestModel: SignInShowModels.Date.RequestModel)
    func fetchDepartments(withRequestModel requestModel: SignInShowModels.Department.RequestModel)
}

protocol SignInShowDataStore {
    var cities: [City]! { get set }
    var laundryID: String! { get set }
    var selectedCityID: String! { get set }
}

class SignInShowInteractor: ShareInteractor, SignInShowBusinessLogic, SignInShowDataStore {
    // MARK: - Properties
    var presenter: SignInShowPresentationLogic?
    var worker: SignInShowWorker?
    
    let operatorCode = [ "050", "052", "053", "054", "055" ]

    // SignInShowDataStore protocol implementation
    var laundryID: String! = "0"
    var cities: [City]! = [City]()
    var selectedCityID: String! = "0"
    
    
    // MARK: - Business logic implementation
    func saveSelectedCityID(_ value: String) {
        self.selectedCityID = value
    }
    
    func fetchCities(withRequestModel requestModel: SignInShowModels.City.RequestModel) {
        worker = SignInShowWorker()
        
        // API: Fetch request data
        self.appDependency.restAPIManager.fetchRequest(withRequestType: .getCitiesList(nil, false), andResponseType: ResponseAPICities.self, completionHandler: { [unowned self] responseAPI in
            if let result = responseAPI.model as? ResponseAPICities {
                for model in result.GetCitiesResult {
                    CoreDataManager.instance.updateEntity(withData: EntityUpdateTuple(name:       "City",
                                                                                      predicate:  NSPredicate.init(format: "iD = \(model.ID)"),
                                                                                      model:      model))
                }
            }
            
            let responseModel = SignInShowModels.City.ResponseModel()
            self.presenter?.presentCities(fromResponseModel: responseModel)
        })
    }
    
    func fetchLaundry(withRequestModel requestModel: SignInShowModels.Laundry.RequestModel) {
        worker = SignInShowWorker()
        
        // API: Fetch request data
        self.appDependency.restAPIManager.fetchRequest(withRequestType: .getLaundryInfo([ "city_id": self.selectedCityID ], false), andResponseType: ResponseAPILaundryResult.self, completionHandler: { [unowned self] responseAPI in
            if let result = responseAPI.model as? ResponseAPILaundryResult {
                let model = result.GetLaundryByCityResult
                self.laundryID = "\(model.ID)"
                
                CoreDataManager.instance.updateEntity(withData: EntityUpdateTuple(name:       "Laundry",
                                                                                  predicate:  NSPredicate.init(format: "iD == %@", self.laundryID),
                                                                                  model:      model))
            }
            
            let responseModel = SignInShowModels.Laundry.ResponseModel()
            self.presenter?.presentLaundry(fromResponseModel: responseModel)
        })
    }
    
    func fetchDeliveryDates(withRequestModel requestModel: SignInShowModels.Date.RequestModel) {
        worker = SignInShowWorker()
        
        // API: Fetch request data
        self.appDependency.restAPIManager.fetchRequest(withRequestType: .getDeliveryDatesList([ "laundry_id": self.laundryID ], false), andResponseType: ResponseAPIDeliveryDatesResult.self, completionHandler: { [unowned self] responseAPI in
            if let result = responseAPI.model as? ResponseAPIDeliveryDatesResult {
                for model in result.GetDeliveryDatesResult {
                    let predicate = NSPredicate.init(format: "fromDate == %@ AND toDate == %@ AND laundryId == \(model.LaundryId) AND type == \(model.Type) AND weekDay = \(model.WeekDay)", model.FromDate, model.ToDate, model.LaundryId)
                    
                    CoreDataManager.instance.updateEntity(withData: EntityUpdateTuple(name:       "DeliveryDate",
                                                                                      predicate:  predicate,
                                                                                      model:      model))
                }
            }
            
            let responseModel = SignInShowModels.Date.ResponseModel()
            self.presenter?.presentDeliveryDates(fromResponseModel: responseModel)
        })
    }

    func fetchCollectionDates(withRequestModel requestModel: SignInShowModels.Date.RequestModel) {
        worker = SignInShowWorker()
        
        // API: Fetch request data
        self.appDependency.restAPIManager.fetchRequest(withRequestType: .getCollectionDatesList([ "laundry_id": self.laundryID ], false), andResponseType: ResponseAPICollectionDatesResult.self, completionHandler: { [unowned self] responseAPI in
            if let result = responseAPI.model as? ResponseAPICollectionDatesResult {
                for model in result.GetCollectionDatesResult {
                    let predicate = NSPredicate.init(format: "fromDate == %@ AND toDate == %@ AND laundryId == \(model.LaundryId) AND type == \(model.Type) AND weekDay = \(model.WeekDay)", model.FromDate, model.ToDate, model.LaundryId)
                    
                    CoreDataManager.instance.updateEntity(withData: EntityUpdateTuple(name:       "CollectionDate",
                                                                                      predicate:  predicate,
                                                                                      model:      model))
                }
            }
            
            let responseModel = SignInShowModels.Date.ResponseModel()
            self.presenter?.presentCollectionDates(fromResponseModel: responseModel)
        })
    }
    
    func fetchDepartments(withRequestModel requestModel: SignInShowModels.Department.RequestModel) {
        worker = SignInShowWorker()
        
        // API: Fetch request data
        self.appDependency.restAPIManager.fetchRequest(withRequestType: .getDepartmentsList([ "laundry_id": self.laundryID ], false), andResponseType: ResponseAPIDepartmentsResult.self, completionHandler: { [unowned self] responseAPI in
            if let result = responseAPI.model as? ResponseAPIDepartmentsResult {
                for model in result.GetDepartmentsResult {
                    let predicate = NSPredicate.init(format: "departmentId == \(model.DepartmentId)")
                    
                    CoreDataManager.instance.updateEntity(withData: EntityUpdateTuple(name:       "Department",
                                                                                      predicate:  predicate,
                                                                                      model:      model))
                }
            }
            
            let responseModel = SignInShowModels.Department.ResponseModel()
            self.presenter?.presentDepartments(fromResponseModel: responseModel)
        })
    }
}
