//
//  OrdersShowViewController.swift
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
import SKStyleKit

// MARK: - Input & Output protocols
protocol OrdersShowDisplayLogic: class {
    func displayOrders(fromViewModel viewModel: OrdersShowModels.OrderItem.ViewModel)
}

class OrdersShowViewController: UIViewController {
    // MARK: - Properties
    var interactor: OrdersShowBusinessLogic?
    var router: (NSObjectProtocol & OrdersShowRoutingLogic & OrdersShowDataPassing)?
    

    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint! {
        didSet {
            tableViewTopConstraint.constant = smallDevices.contains(UIDevice.current.deviceType) ? -64.0 : 0.0
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
        let interactor              =   OrdersShowInteractor(AppDependency())
        let presenter               =   OrdersShowPresenter()
        let router                  =   OrdersShowRouter()
        
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadViewSettings()
    }
    
    
    // MARK: - Custom Functions
    func loadViewSettings() {
        let requestModel = OrdersShowModels.OrderItem.RequestModel()
        self.interactor?.fetchOrders(withRequestModel: requestModel)
    }
}


// MARK: - OrdersShowDisplayLogic
extension OrdersShowViewController: OrdersShowDisplayLogic {
    func displayOrders(fromViewModel viewModel: OrdersShowModels.OrderItem.ViewModel) {
        // NOTE: Display the result from the Presenter
        if let orders = self.router?.dataStore?.orders, orders.count > 0 {
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
            })
        }
    }
}


// MARK: - UITableViewDataSource
extension OrdersShowViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        var numberOfSections: NSInteger = 0
        
        if let orders = self.router?.dataStore?.orders, orders.count > 0 {
            self.tableView.backgroundView = nil
            numberOfSections = 1
        }
        
        else {
            let emptyLabel = UILabel(frame: CGRect.init(origin: .zero, size: self.tableView.bounds.size))
            emptyLabel.text = "Orders List is Empty".localized()
            emptyLabel.textAlignment = .center
            self.tableView.backgroundView = emptyLabel
        }
        
        return numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.router?.dataStore?.orders == nil) ? 0 : self.router!.dataStore!.orders!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "OrderCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! OrderTableViewCell
        let order = self.router!.dataStore!.orders[indexPath.row]
        
        cell.setup(withItem: order, andIndexPath: indexPath)
        
        return cell
    }
}


// MARK: - UITableViewDelegate
extension OrdersShowViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 4.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView.init(frame: CGRect.init(origin: .zero, size: CGSize.init(width: tableView.bounds.width, height: 4.0)))
        let footerViewStyle = SKStyleKit.style(withName: "sideMenuStyle")!
        footerView.backgroundColor = footerViewStyle.backgroundColor
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.router?.routeToOrderShowScene()
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! OrderTableViewCell
        cell.labelsView.backgroundColor = UIColor.white.darkened(amount: 0.2)
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! OrderTableViewCell
        cell.labelsView.backgroundColor = UIColor.white
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    }
}

