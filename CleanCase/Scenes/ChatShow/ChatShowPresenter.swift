//
//  ChatShowPresenter.swift
//  CleanCase
//
//  Created by msm72 on 08.02.2018.
//  Copyright (c) 2018 msm72. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

// MARK: - Presentation Logic protocols
protocol ChatShowPresentationLogic {
    func presentMessages(fromResponseModel responseModel: ChatShowModels.Message.ResponseModel)
    func presentSendMessage(fromResponseModel responseModel: ChatShowModels.Message.ResponseModel)
}

class ChatShowPresenter: ChatShowPresentationLogic {
    // MARK: - Properties
    weak var viewController: ChatShowDisplayLogic?
    
    
    // MARK: - Class Initialization
    deinit {
        Logger.log(message: "Success", event: .Severe)
    }
    

    // MARK: - Presentation Logic implementation
    func presentMessages(fromResponseModel responseModel: ChatShowModels.Message.ResponseModel) {
        let viewModel = ChatShowModels.Message.ViewModel()
        viewController?.displayMessages(fromViewModel: viewModel)
    }
    
    func presentSendMessage(fromResponseModel responseModel: ChatShowModels.Message.ResponseModel) {
        let viewModel = ChatShowModels.Message.ViewModel(error: responseModel.error)
        viewController?.displaySendMessage(fromViewModel: viewModel)
    }
}
