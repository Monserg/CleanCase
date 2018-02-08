//
//  WriteUsShowViewController.swift
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

// MARK: - Input & Output protocols
protocol WriteUsShowDisplayLogic: class {
    func displaySomething(fromViewModel viewModel: WriteUsShowModels.Something.ViewModel)
}

class WriteUsShowViewController: UIViewController {
    // MARK: - Properties
    var interactor: WriteUsShowBusinessLogic?
    var router: (NSObjectProtocol & WriteUsShowRoutingLogic & WriteUsShowDataPassing)?
    
    
    // MARK: - IBOutlets
    
    
    // MARK: - Class Initialization
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    
    // MARK: - Setup
    private func setup() {
        let viewController          =   self
        let interactor              =   WriteUsShowInteractor()
        let presenter               =   WriteUsShowPresenter()
        let router                  =   WriteUsShowRouter()
        
        viewController.interactor   =   interactor
        viewController.router       =   router
        interactor.presenter        =   presenter
        presenter.viewController    =   viewController
        router.viewController       =   viewController
        router.dataStore            =   interactor
    }
    
    
    // MARK: - Routing
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    
    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addBackBarButtonItem()
        self.addBasketBarButtonItem(true)
        self.displayLaundryInfo(withName: Laundry.name, andPhoneNumber: "\(Laundry.phoneNumber ?? "")")

        viewSettingsDidLoad()
    }
    
    
    // MARK: - Custom Functions
    func viewSettingsDidLoad() {
        let requestModel = WriteUsShowModels.Something.RequestModel()
        interactor?.doSomething(withRequestModel: requestModel)
    }
}


// MARK: - WriteUsShowDisplayLogic
extension WriteUsShowViewController: WriteUsShowDisplayLogic {
    func displaySomething(fromViewModel viewModel: WriteUsShowModels.Something.ViewModel) {
        // NOTE: Display the result from the Presenter
//         nameTextField.text = viewModel.name
    }
}
