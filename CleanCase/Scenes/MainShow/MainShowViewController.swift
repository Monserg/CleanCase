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

    private var activeViewController: UIViewController? {
        didSet {
            self.removeInactiveViewController(oldValue)
            self.updateActiveViewController()
        }
    }
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var basketBarButtonItem: UIBarButtonItem!
    
    
    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addNavigationBarShadow()
        self.viewSettingsDidLoad()
        self.setupSideMenu()
        self.activeViewController = self.nextViewController(fromStoryboardName: "OrdersControl")
    }
        
    
    // MARK: - Custom Functions
    fileprivate func viewSettingsDidLoad() {
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
            SwiftSpinner.show("Loading App data...".localized(), animated: true)

            if let nextScene = scene as? LeftSideMenuShowModels.MenuItems.ResponseModel.MenuItem  {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + dispatchTimeDelay * 3) {
                    leftSideMenuNC.dismiss(animated: true, completion: {})
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + dispatchTimeDelay * 7) {
                        if nextScene.storyboardName == "AgreementShow" {
                            SwiftSpinner.hide()
                            self.createPopover(withName: nextScene.storyboardName)
                        }
                            
                        else if nextScene.storyboardName != "XXX" {
                            self.activeViewController = self.nextViewController(fromStoryboardName: nextScene.storyboardName)
                            self.basketBarButtonItem.image = (nextScene.hasShoppingBasketIcon) ? UIImage.init(named: "icon-shopping-basket-empty") : nil
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
    
    private func removeInactiveViewController(_ inactiveViewController: UIViewController?) {
        if let inActiveVC = inactiveViewController {
            // call before removing child view controller's view from hierarchy
            inActiveVC.willMove(toParentViewController: nil)
            
            inActiveVC.view.removeFromSuperview()
            
            // call after removing child view controller's view from hierarchy
            inActiveVC.removeFromParentViewController()
        }
    }
    
    private func updateActiveViewController() {
        if let activeVC = activeViewController {
            // call before adding child view controller's view as subview
            addChildViewController(activeVC)
            
            activeVC.view.frame = containerView.bounds
            containerView.addSubview(activeVC.view)
            
            // call before adding child view controller's view as subview
            activeVC.didMove(toParentViewController: self)
        }
        
        guard (self.activeViewController as? AboutShowViewController) == nil else { return }
        
        SwiftSpinner.hide()
    }
    
    fileprivate func nextViewController(fromStoryboardName storyboardName: String) -> UIViewController {
        return UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: storyboardName + "VC")
    }

    
    // MARK: - Actions
    @IBAction func handlerSideMenuBarButtonTapped(_ sender: UIBarButtonItem) {
        // Show side menu
        present(sideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    @IBAction func handlerBasketBarButtonItemTapped(_ sender: UIBarButtonItem) {
    
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
