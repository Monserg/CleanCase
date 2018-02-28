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
    fileprivate var order: Order?
    fileprivate var isDeliveryTermShow: Bool = false
    fileprivate var lastMessageTimer: CustomTimer!

    var backgroundTaskIdentifier: UIBackgroundTaskIdentifier?

    
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

    @IBOutlet weak var buttonsStackViewHeightConstraint: NSLayoutConstraint! {
        didSet {
            buttonsStackViewHeightConstraint.constant *= heightRatio
        }
    }
    
    @IBOutlet weak var buttonsStackViewWidthConstraint: NSLayoutConstraint! {
        didSet {
            buttonsStackViewWidthConstraint.constant *= widthRatio
        }
    }
    
    
    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addNavigationBarShadow()
        self.loadViewSettings()
        self.setupSideMenu()
    
        // Add Timer Observer
        NotificationCenter.default.addObserver(self,
                                               selector:    #selector(handlerTimerNotification),
                                               name:        Notification.Name("TimerNotificationComplete"),
                                               object:      nil)
        
        backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            UIApplication.shared.endBackgroundTask(self.backgroundTaskIdentifier!)
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadOrder()
        self.runGetLastClientMessage()
    }
    
    deinit {
        Logger.log(message: "Remove all Observers", event: .Info)
        NotificationCenter.default.removeObserver(self)
    }
        
    
    // MARK: - Custom Functions
    fileprivate func loadViewSettings() {
        self.displayLaundryInfo(withName: Laundry.name, andPhoneNumber: "\(Laundry.phoneNumber ?? "")")
    }
    
    fileprivate func loadOrder() {
        self.order = Order.firstToShow
        self.myOrderView.isHidden = (self.order == nil) ? true : false
    }
    
    fileprivate func setupSideMenu() {
        sideMenuManager = SideMenuManager.default
        let leftSideMenuNC = storyboard!.instantiateViewController(withIdentifier: "LeftSideMenuNC") as! UISideMenuNavigationController
        
        sideMenuManager.menuLeftNavigationController    =   leftSideMenuNC
        sideMenuManager.menuRightNavigationController   =   nil

        sideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        sideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
        sideMenuManager.menuWidth           =   270 * widthRatio
        sideMenuManager.menuDismissOnPush   =   true
        sideMenuManager.menuPresentMode     =   .menuSlideIn
        
        let leftSideMenuShowVC              =   leftSideMenuNC.viewControllers.first as! LeftSideMenuShowViewController
        
        sideMenuManager.menuLeftNavigationController    =   leftSideMenuNC
        sideMenuManager.menuRightNavigationController   =   nil

        // Handler left side menu item select
        leftSideMenuShowVC.handlerMenuItemSelectCompletion = { [unowned self] (scene) in
            if let nextScene = scene as? LeftSideMenuShowModels.MenuItems.ResponseModel.MenuItem  {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + dispatchTimeDelay * 3) {
                    leftSideMenuNC.dismiss(animated: true, completion: {})
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + dispatchTimeDelay * 7) {
                        if nextScene.storyboardName == "AgreementShow" {
                            SwiftSpinner.hide()
                            self.createPopover(withName: nextScene.storyboardName, completion: { [unowned self] in
                                self.isDeliveryTermShow = false
                            })
                            
                            self.isDeliveryTermShow = true
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
        let destinationVC = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: storyboardName + "VC")
        
        if storyboardName == "OrderShow", let order = self.order {
            (destinationVC as! OrderShowViewController).saveOrderID(order.orderID)
        }
        
        return destinationVC
    }
    
    fileprivate func runGetLastClientMessage() {
        if let orders = CoreDataManager.instance.readEntities(withName:                 "Order",
                                                              withPredicateParameters:  nil,
                                                              andSortDescriptor:        NSSortDescriptor.init(key: "orderID", ascending: false)), orders.count > 0 {
            self.lastMessageTimer = CustomTimer.init(withSecondsInterval: 30)
            self.lastMessageTimer.resume()
            
            self.lastMessageTimer.eventHandler = {
                // API
                self.checkNetworkConnection({ connectionSuccess in
                    if connectionSuccess {
                        _ = UpdateManager().getLastClientMessage({ [unowned self] changeOrderStatusSuccess in
                            if changeOrderStatusSuccess && self.navigationController!.viewControllers.last!.isKind(of: OrderShowViewController.self) {
                                Logger.log(message: "Post Notification to complete change current Order status", event: .Debug)
                                NotificationCenter.default.post(name: Notification.Name("ChangeOrderStatusComplete"), object: nil)
                            }
                        })
                    }
                })
            }
        }
    }

    
    // MARK: - Actions
    @IBAction func handlerSideMenuBarButtonTapped(_ sender: UIBarButtonItem) {
        // Show side menu
        Logger.log(message: "Display left side menu", event: .Info)
        present(sideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    @IBAction func handlerOrderButtonTapped(_ sender: UIButton) {
        self.show(self.nextViewController(fromStoryboardName: (sender.tag == 0) ? "OrderCreate" : "OrderShow"), sender: nil)
    }
    
    @objc func handlerTimerNotification(_ notification: Notification) {
        if !isDeliveryTermShow && sideMenuManager.menuLeftNavigationController!.isHidden {
            if Order.firstToDelivery != nil {
                DispatchQueue.main.async(execute: {
                    Logger.log(message: "Display DeliveryTermsShow scene", event: .Verbose)
                    self.createPopover(withName: "DeliveryTermsShow", completion: { [unowned self] in
                        self.isDeliveryTermShow = false
                    })
                    
                    self.isDeliveryTermShow = true
                })
            }
        }
    }
}


// MARK: - UISideMenuNavigationControllerDelegate
extension MainShowViewController: UISideMenuNavigationControllerDelegate {
    func sideMenuWillAppear(menu: UISideMenuNavigationController, animated: Bool) {
        Logger.log(message: "SideMenu Appearing! (animated: \(animated))", event: .Info)
    }
    
    func sideMenuDidAppear(menu: UISideMenuNavigationController, animated: Bool) {
        Logger.log(message: "SideMenu Appeared! (animated: \(animated))", event: .Info)
    }
    
    func sideMenuWillDisappear(menu: UISideMenuNavigationController, animated: Bool) {
        Logger.log(message: "SideMenu Disappearing! (animated: \(animated))", event: .Info)
    }
    
    func sideMenuDidDisappear(menu: UISideMenuNavigationController, animated: Bool) {
        Logger.log(message: "SideMenu Disappeared! (animated: \(animated))", event: .Info)
    }
}
