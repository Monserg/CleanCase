//
//  LeftSideMenuShowViewController.swift
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
import SKStyleKit
import Device_swift
import DynamicColor
import Localize_Swift

// MARK: - Input & Output protocols
protocol LeftSideMenuShowDisplayLogic: class {
    func displayMenuItems(fromViewModel viewModel: LeftSideMenuShowModels.MenuItems.ViewModel)
}

class LeftSideMenuShowViewController: UIViewController {
    // MARK: - Properties
    var interactor: LeftSideMenuShowBusinessLogic?
    var router: (NSObjectProtocol & LeftSideMenuShowRoutingLogic & LeftSideMenuShowDataPassing)?
    
    var handlerMenuItemSelectCompletion: HandlerPassDataCompletion?

    
    // MARK: - IBOutlets
    @IBOutlet weak var languageSwitch: UISwitch! {
        didSet {
            languageSwitch.isOn = Localize.currentLanguage() == "he"
        }
    }

    @IBOutlet weak var arabicLabel: SKLabel! {
        didSet {
            arabicLabel.text!.localize()
        }
    }
    
    @IBOutlet weak var hebrewLabel: SKLabel! {
        didSet {
            hebrewLabel.text!.localize()
        }
    }
    
    @IBOutlet weak var menuTableView: UITableView! {
        didSet {
            menuTableView.isScrollEnabled = false
            menuTableView.showsVerticalScrollIndicator = false
            menuTableView.delegate = self
            menuTableView.dataSource = self
        }
    }
    
    @IBOutlet weak var menuTableViewTopConstraint: NSLayoutConstraint! {
        didSet {
            let deviceType = UIDevice.current.deviceType
            
            switch deviceType {
            case .iPhone4S, .iPhone5, .iPhone5C, .iPhone5S:
                menuTableViewTopConstraint.constant = 24.0

            default:
                menuTableViewTopConstraint.constant = 44.0
            }
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
        NotificationCenter.default.removeObserver(self)
    }

    
    // MARK: - Setup
    private func setup() {
        let viewController          =   self
        let interactor              =   LeftSideMenuShowInteractor()
        let presenter               =   LeftSideMenuShowPresenter()
        let router                  =   LeftSideMenuShowRouter()
        
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
        
        // Add Language Observer
        self.registerForCustomAppNotifications(withName: NSNotification.Name(rawValue: LCLLanguageChangeNotification))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadMenuItems()
    }
    
    
    // MARK: - Custom Functions
    public func loadMenuItems() {
        let requestModel = LeftSideMenuShowModels.MenuItems.RequestModel()
        self.interactor?.loadMenuItems(withRequestModel: requestModel)
    }
    
    private func localize() {
        DispatchQueue.main.async(execute: {
            self.menuTableView.reloadData()
            self.arabicLabel.text = "Arabic".localized()
            self.hebrewLabel.text = "Hebrew".localized()
        })
    }
    
    
    
    // MARK: - Actions
    @IBAction func handlerSideMenuButtonTapped(_ sender: Any) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + dispatchTimeDelay * 0) {
            self.navigationController?.dismiss(animated: true, completion: {})
        }
    }
    
    @IBAction func handlerChangeState(_ sender: UISwitch) {
        let currentLanguage = sender.isOn ? "he" : "ar"
        UserDefaults.standard.set(currentLanguage, forKey: "languageApp")
        UserDefaults.standard.synchronize()
        
        Localize.setCurrentLanguage(currentLanguage)
    }
    
    override func handlerCustomAppNotification(notification: Notification) {
        self.loadMenuItems()
    }
}


// MARK: - LeftSideMenuShowDisplayLogic
extension LeftSideMenuShowViewController: LeftSideMenuShowDisplayLogic {
    func displayMenuItems(fromViewModel viewModel: LeftSideMenuShowModels.MenuItems.ViewModel) {
        // NOTE: Display the result from the Presenter
        if self.router!.dataStore!.menuItems.count > 0 {
            self.localize()
        }
    }
}



// MARK: - UITableViewDataSource
extension LeftSideMenuShowViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.router?.dataStore?.menuItems.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = self.router!.dataStore!.menuItems[indexPath.row].cellIdentifier
        self.menuTableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        let cell = self.menuTableView!.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let menuItem = self.router!.dataStore!.menuItems[indexPath.row]
        
        // Config cell
        (cell as! ConfigureCell).setup(withItem: menuItem, andIndexPath: indexPath)

        return cell
    }
}


// MARK: - UITableViewDelegate
extension LeftSideMenuShowViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        handlerMenuItemSelectCompletion!(self.router!.dataStore!.menuItems[indexPath.row])
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + dispatchTimeDelay * 0) {
            self.navigationController?.dismiss(animated: true, completion: {})
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.router!.dataStore!.menuItems[indexPath.row].cellHeight * heightRatio
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = self.menuTableView.cellForRow(at: indexPath)!
        cell.contentView.backgroundColor = UIColor.white.darkened(amount: 0.2)
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = self.menuTableView.cellForRow(at: indexPath)!
        let cellStyle = SKStyleKit.style(withName: "sideMenuStyle")!
        cell.contentView.backgroundColor = cellStyle.backgroundColor
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
