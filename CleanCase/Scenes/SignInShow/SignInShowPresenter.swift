//
//  SignInShowPresenter.swift
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

// MARK: - Presentation Logic protocols
protocol SignInShowPresentationLogic {
    func presentClient(fromResponseModel responseModel: SignInShowModels.User.ResponseModel)
    func presentCities(fromResponseModel responseModel: SignInShowModels.City.ResponseModel)
    func presentLaundry(fromResponseModel responseModel: SignInShowModels.Laundry.ResponseModel)
    func presentDeliveryDates(fromResponseModel responseModel: SignInShowModels.Date.ResponseModel)
    func presentCollectionDates(fromResponseModel responseModel: SignInShowModels.Date.ResponseModel)
    func presentDepartments(fromResponseModel responseModel: SignInShowModels.Department.ResponseModel)
}

class SignInShowPresenter: SignInShowPresentationLogic {
    // MARK: - Properties
    weak var viewController: SignInShowDisplayLogic?
    
    
    // MARK: - Class Initialization
    deinit {
        Logger.log(message: "Success", event: .Severe)
    }
    

    // MARK: - Presentation Logic implementation
    func presentClient(fromResponseModel responseModel: SignInShowModels.User.ResponseModel) {
        let viewModel = SignInShowModels.User.ViewModel()
        viewController?.displayClient(fromViewModel: viewModel)
    }

    func presentCities(fromResponseModel responseModel: SignInShowModels.City.ResponseModel) {
        let viewModel = SignInShowModels.City.ViewModel()
        viewController?.displayCities(fromViewModel: viewModel)
    }
    
    func presentLaundry(fromResponseModel responseModel: SignInShowModels.Laundry.ResponseModel) {
        let viewModel = SignInShowModels.Laundry.ViewModel()
        viewController?.initializationLaundryInfo(fromViewModel: viewModel)
    }
    
    func presentDeliveryDates(fromResponseModel responseModel: SignInShowModels.Date.ResponseModel) {
        let viewModel = SignInShowModels.Date.ViewModel()
        viewController?.initializationDeliveryDates(fromViewModel: viewModel)
    }

    func presentCollectionDates(fromResponseModel responseModel: SignInShowModels.Date.ResponseModel) {
        let viewModel = SignInShowModels.Date.ViewModel()
        viewController?.initializationCollectionDates(fromViewModel: viewModel)
    }
    
    func presentDepartments(fromResponseModel responseModel: SignInShowModels.Department.ResponseModel) {
        let viewModel = SignInShowModels.Department.ViewModel()
        viewController?.initializationDepartments(fromViewModel: viewModel)
    }
}
