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

class MainShowViewController: UIViewController {
    // MARK: - Properties
    fileprivate var sideMenuManager: SideMenuManager!

    
    // MARK: - IBOutlets
    @IBOutlet weak var basketBarButtonItem: UIBarButtonItem!
    
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

    
    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addNavigationBarShadow()
        self.loadViewSettings()
        self.setupSideMenu()
    }
        
    
    // MARK: - Custom Functions
    fileprivate func loadViewSettings() {
        self.displayLaundryInfo(withName: Laundry.name, andPhoneNumber: "\(Laundry.phoneNumber ?? "")")
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
            if let nextScene = scene as? LeftSideMenuShowModels.MenuItems.ResponseModel.MenuItem  {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + dispatchTimeDelay * 3) {
                    leftSideMenuNC.dismiss(animated: true, completion: {})
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + dispatchTimeDelay * 7) {
                        if nextScene.storyboardName == "AgreementShow" {
                            SwiftSpinner.hide()
                            self.createPopover(withName: nextScene.storyboardName)
                        }
                            
                        else if nextScene.storyboardName != "XXX" {
                            self.show(self.nextViewController(fromStoryboardName: nextScene.storyboardName), sender: nil)
                        }
                        
                        // FIXME: - DELETE AFTER CREATE 'WORKING HOURS SCENE'
                        else {
                            SwiftSpinner.hide()
                        }
                    }
                }
            }
        }
    }
    
    fileprivate func nextViewController(fromStoryboardName storyboardName: String) -> UIViewController {
        return UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: storyboardName + "VC")
    }

    
    // MARK: - Actions
    @IBAction func handlerSideMenuBarButtonTapped(_ sender: UIBarButtonItem) {
        // Show side menu
        present(sideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    @IBAction func handlerOrderButtonTapped(_ sender: UIButton) {
        self.show(self.nextViewController(fromStoryboardName: (sender.tag == 0) ? "OrderCreate" : "OrderShow"), sender: nil)
    }
    
    
    // FIXME: - DELETE AFTER TEST
    @IBAction func deliveryButtonTapped(_ sender: Any) {
        self.createPopover(withName: "DeliveryTermsShow")
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
