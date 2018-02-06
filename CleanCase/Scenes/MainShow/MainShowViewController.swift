//
//  MainShowViewController.swift
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
import SideMenu
import SwiftSpinner

// MARK: - Input & Output protocols
protocol MainShowDisplayLogic: class {
    func displaySomething(fromViewModel viewModel: MainShowModels.Something.ViewModel)
}

class MainShowViewController: UIViewController {
    // MARK: - Properties
    var interactor: MainShowBusinessLogic?
    var router: (NSObjectProtocol & MainShowRoutingLogic & MainShowDataPassing)?
    
    fileprivate var sideMenuManager: SideMenuManager!

    
    // MARK: - IBOutlets
    @IBOutlet weak var createOrderView: UIView! {
        didSet {
            createOrderView.isHidden = false
        }
    }
    
    @IBOutlet weak var myOrderView: UIView! {
        didSet {
            
        }
    }
    
    @IBOutlet weak var createOrderButton: UIButton! {
        didSet {
            
        }
    }
    
    @IBOutlet weak var myOrderButton: UIButton! {
        didSet {

        }
    }
        
    @IBOutlet var orderButtonsHeightConstraintsCollection: [NSLayoutConstraint]! {
        didSet {
            _ = orderButtonsHeightConstraintsCollection.map({ $0.constant *= heightRatio })
        }
    }
    
    @IBOutlet var orderButtonsWidthConstraintsCollection: [NSLayoutConstraint]! {
        didSet {
            _ = orderButtonsWidthConstraintsCollection.map({ $0.constant *= widthRatio })
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
        let interactor              =   MainShowInteractor()
        let presenter               =   MainShowPresenter()
        let router                  =   MainShowRouter()
        
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
        
        self.viewSettingsDidLoad()
        self.setupSideMenu()
    }
        
    
    // MARK: - Custom Functions
    fileprivate func viewSettingsDidLoad() {
        self.displayLaundryInfo(withName: Laundry.name, andPhoneNumber: "\(Laundry.phoneNumber ?? "")")

        let requestModel = MainShowModels.Something.RequestModel()
        interactor?.doSomething(withRequestModel: requestModel)
    }
    
    fileprivate func setupSideMenu() {
        sideMenuManager = SideMenuManager.default
        let leftSideMenuNC = storyboard!.instantiateViewController(withIdentifier: "LeftSideMenuNC") as! UISideMenuNavigationController
        
        sideMenuManager.menuLeftNavigationController = leftSideMenuNC
        
        sideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        sideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
        sideMenuManager.menuWidth           =   270 * widthRatio
        sideMenuManager.menuDismissOnPush   =   true
        sideMenuManager.menuPresentMode     =   .menuSlideIn
        
        let leftSideMenuShowVC  =   leftSideMenuNC.viewControllers.first as! LeftSideMenuShowViewController
        
        sideMenuManager.menuLeftNavigationController = leftSideMenuNC
        
        // Handler left side menu item select
        leftSideMenuShowVC.handlerMenuItemSelectCompletion = { [unowned self] (scene) in
            if let nextScene = scene as? LeftSideMenuShowModels.MenuItems.ResponseModel.MenuItem, nextScene.storyboardID != "SignOut"  {
                let storyboard = UIStoryboard(name: nextScene.storyboardName, bundle: nil)
                let destinationVC = storyboard.instantiateViewController(withIdentifier: nextScene.storyboardID)
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + dispatchTimeDelay * 3) {
                    leftSideMenuNC.dismiss(animated: true, completion: {})
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + dispatchTimeDelay * 7) {
                        if nextScene.storyboardID == "AgreementShowVC" {
                            self.createPopover(withName: nextScene.storyboardName)
                        }
                            
                        else {
                            self.show(destinationVC, sender: nil)
                        }
                    }
                }
            }
            
//            else {
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + dispatchTimeDelay * 3) {
//                    leftSideMenuNC.dismiss(animated: true, completion: {})
//
//                    // Close App
//                    self.showAlertView(withTitle: "Info", andMessage: "Our App close after 15 sec", needCancel: true, completion: { [unowned self] result in
//                        if result {
//                            SwiftSpinner.show("Application is closing...".localized(), animated: true)
//                            self.view.isUserInteractionEnabled = false
//                            self.navigationItem.leftBarButtonItem?.isEnabled = false
//
//                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + dispatchTimeDelay * 90) {
//                                exit(1)
//                            }
//                        }
//                    })
//                }
//            }
        }
    }

    
    // MARK: - Actions
    @IBAction func handlerSideMenuBarButtonTapped(_ sender: UIBarButtonItem) {
        // Show side menu
        present(sideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }

    @IBAction func handlerCreateOrderButtonTapped(_ sender: Any) {
        print("Create Order button tapped...")
    }
    
    @IBAction func handlerMyOrderButtonTapped(_ sender: Any) {
        print("My Order button tapped...")
    }
    
    // FIXME: - DELETE AFTER TEST
    @IBAction func handlerPopoverButtonTapped(_ sender: Any) {
        self.createPopover(withName: "AgreementShow")
    }
}


// MARK: - MainShowDisplayLogic
extension MainShowViewController: MainShowDisplayLogic {
    func displaySomething(fromViewModel viewModel: MainShowModels.Something.ViewModel) {
        // NOTE: Display the result from the Presenter

    }
}


// MARK: - UISideMenuNavigationControllerDelegate
extension MainShowViewController: UISideMenuNavigationControllerDelegate {
    func sideMenuWillAppear(menu: UISideMenuNavigationController, animated: Bool) {
        print("SideMenu Appearing! (animated: \(animated))")
    }
    
    func sideMenuDidAppear(menu: UISideMenuNavigationController, animated: Bool) {
        print("SideMenu Appeared! (animated: \(animated))")
    }
    
    func sideMenuWillDisappear(menu: UISideMenuNavigationController, animated: Bool) {
        print("SideMenu Disappearing! (animated: \(animated))")
    }
    
    func sideMenuDidDisappear(menu: UISideMenuNavigationController, animated: Bool) {
        print("SideMenu Disappeared! (animated: \(animated))")
    }
}
