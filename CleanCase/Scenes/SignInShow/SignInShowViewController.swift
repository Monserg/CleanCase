//
//  SignInShowViewController.swift
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
protocol SignInShowDisplayLogic: class {
    func displayCities(fromViewModel viewModel: SignInShowModels.City.ViewModel)
}

class SignInShowViewController: UIViewController {
    // MARK: - Properties
    var interactor: SignInShowBusinessLogic?
    var router: (NSObjectProtocol & SignInShowRoutingLogic & SignInShowDataPassing)?
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var laundryButton: UIButton! {
        didSet {
            
        }
    }
    
    
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
        let interactor              =   SignInShowInteractor(AppDependency())
        let presenter               =   SignInShowPresenter()
        let router                  =   SignInShowRouter()
        
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
        
        viewSettingsDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    
    // MARK: - Custom Functions
    func viewSettingsDidLoad() {
        let requestModel = SignInShowModels.City.RequestModel()
        interactor?.fetchCities(withRequestModel: requestModel)
    }
    
    
    // MARK: - Actions
    @IBAction func handlerSaveButtonTap(_ sender: Any) {
        print("Save button tapped...")
    }
}


// MARK: - SignInShowDisplayLogic
extension SignInShowViewController: SignInShowDisplayLogic {
    func displayCities(fromViewModel viewModel: SignInShowModels.City.ViewModel) {
        // NOTE: Display the result from the Presenter

    }
}
