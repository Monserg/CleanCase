//
//  SignInShowRouter.swift
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
@objc protocol SignInShowRoutingLogic {
//    func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol SignInShowDataPassing {
    var dataStore: SignInShowDataStore? { get }
}

class SignInShowRouter: NSObject, SignInShowRoutingLogic, SignInShowDataPassing {
    // MARK: - Properties
    weak var viewController: SignInShowViewController?
    var dataStore: SignInShowDataStore?
    
    
    // MARK: - Class Initialization
    deinit {
        Logger.log(message: "Class deinit", event: .Severe)
    }
    

    // MARK: - Routing
//    func routeToSomewhere(segue: UIStoryboardSegue?) {
//        if let segue = segue {
//            let destinationVC = segue.destination as! SomewhereViewController
//            var destinationDS = destinationVC.router!.dataStore!
//            passDataToSomewhere(source: dataStore!, destination: &destinationDS)
//        } else {
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let destinationVC = storyboard.instantiateViewController(withIdentifier: "SomewhereViewController") as! SomewhereViewController
//            var destinationDS = destinationVC.router!.dataStore!
//            passDataToSomewhere(source: dataStore!, destination: &destinationDS)
//            navigateToSomewhere(source: viewController!, destination: destinationVC)
//        }
//    }
    
    
    // MARK: - Navigation
//    func navigateToSomewhere(source: SignInShowViewController, destination: SomewhereViewController) {
//        source.show(destination, sender: nil)
//    }
    
    
    // MARK: - Passing data
//    func passDataToSomewhere(source: SignInShowDataStore, destination: inout SomewhereDataStore) {
//        destination.name = source.name
//    }
}
