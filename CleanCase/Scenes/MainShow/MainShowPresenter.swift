//
//  MainShowPresenter.swift
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
protocol MainShowPresentationLogic {
    func presentSomething(fromResponseModel responseModel: MainShowModels.Something.ResponseModel)
}

class MainShowPresenter: MainShowPresentationLogic {
    // MARK: - Properties
    weak var viewController: MainShowDisplayLogic?
    
    
    // MARK: - Presentation Logic implementation
    func presentSomething(fromResponseModel responseModel: MainShowModels.Something.ResponseModel) {
        let viewModel = MainShowModels.Something.ViewModel()
        viewController?.displaySomething(fromViewModel: viewModel)
    }
}
