//
//  OrderCreateViewController.swift
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
protocol OrderCreateDisplayLogic: class {
    func displaySomething(fromViewModel viewModel: OrderCreateModels.Something.ViewModel)
}

class OrderCreateViewController: UIViewController {
    // MARK: - Properties
    var interactor: OrderCreateBusinessLogic?
    var router: (NSObjectProtocol & OrderCreateRoutingLogic & OrderCreateDataPassing)?
    
    
    // MARK: - IBOutlets
//     @IBOutlet weak var nameTextField: UITextField!
    
    
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
        let interactor              =   OrderCreateInteractor()
        let presenter               =   OrderCreatePresenter()
        let router                  =   OrderCreateRouter()
        
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
        self.displayLaundryInfo(withName: Laundry.name, andPhoneNumber: "\(Laundry.phoneNumber ?? "")")
        
        viewSettingsDidLoad()
    }
    
    
    // MARK: - Custom Functions
    func viewSettingsDidLoad() {
        let requestModel = OrderCreateModels.Something.RequestModel()
        interactor?.doSomething(withRequestModel: requestModel)
    }
}


// MARK: - OrderCreateDisplayLogic
extension OrderCreateViewController: OrderCreateDisplayLogic {
    func displaySomething(fromViewModel viewModel: OrderCreateModels.Something.ViewModel) {
        // NOTE: Display the result from the Presenter
//         nameTextField.text = viewModel.name
    }
}
