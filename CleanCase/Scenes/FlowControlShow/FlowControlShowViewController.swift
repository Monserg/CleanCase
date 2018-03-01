//
//  FlowControlShowViewController.swift
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
import SwiftSpinner
import Device_swift

// MARK: - Input & Output protocols
protocol FlowControlShowDisplayLogic: class {
    func checkAppWorkingVersion(fromViewModel viewModel: FlowControlShowModels.Version.ViewModel)
}

class FlowControlShowViewController: UIViewController {
    // MARK: - Properties
    var interactor: FlowControlShowBusinessLogic?
    var router: NSObjectProtocol?
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var flowControlLabel: UILabel! {
        didSet {
            flowControlLabel.text = flowControlLabel.text?.localized()
            flowControlLabel.isHidden = true
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

    deinit {
        Logger.log(message: "Success", event: .Severe)
    }
    
    
    // MARK: - Setup
    private func setup() {
        let viewController          =   self
        let interactor              =   FlowControlShowInteractor(AppDependency())
        let presenter               =   FlowControlShowPresenter()
        
        viewController.interactor   =   interactor
        interactor.presenter        =   presenter
        presenter.viewController    =   viewController
    }
    
    
    // MARK: - Routing
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
        
        SwiftSpinner.hide()
    }
    
    
    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadViewSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    
    // MARK: - Custom Functions
    private func loadViewSettings() {
        checkNetworkConnection({ [unowned self] success in
            SwiftSpinner.show("Loading App data...".localized(), animated: true)

            if success {
                let requestModel = FlowControlShowModels.Version.RequestModel()
                self.interactor?.fetchAppWorkingVersion(withRequestModel: requestModel)
            }
            
            else {
                self.routeToNextScene()
            }
        })
    }
    
    fileprivate func routeToNextScene() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + dispatchTimeDelay * 17) {
            guard Laundry.name != "My Laundry".localized() || Laundry.phoneNumber != nil else {
                Logger.log(message: "Route to SignInShow scene", event: .Info)
                self.performSegue(withIdentifier: "SignInShowSegue", sender: nil)
                return
            }
            
            Logger.log(message: "Route to MainShow scene", event: .Info)
//            self.performSegue(withIdentifier: "OnboardShowSegue", sender: nil)
            self.performSegue(withIdentifier: "MainShowSegue", sender: nil)
        }
    }
}


// MARK: - FlowControlShowDisplayLogic
extension FlowControlShowViewController: FlowControlShowDisplayLogic {
    func checkAppWorkingVersion(fromViewModel viewModel: FlowControlShowModels.Version.ViewModel) {
        // NOTE: Display the result from the Presenter
        if viewModel.isEqual || DeviceType.current == .simulator {
            Logger.log(message: "App Working & Current Versions are equal or Device type is Simulator", event: .Verbose)
            self.routeToNextScene()
        }
        
        else {
            Logger.log(message: "App Working & Current Versions are not equal", event: .Verbose)
            SwiftSpinner.sharedInstance.title = "Please, restart App...".localized()
            
            DispatchQueue.main.async(execute: {
                if let url = URL(string: "https://itunes.apple.com/app/id1353769148"), UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                        
                    else {
                        UIApplication.shared.openURL(url)
                    }
                }
                
                self.flowControlLabel.isHidden = false
            })
        }
    }
}
