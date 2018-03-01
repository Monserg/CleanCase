//
//  OrderShowViewController.swift
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
protocol OrderShowDisplayLogic: class {
    func displayCancelOrder(fromViewModel viewModel: OrderShowModels.Order.ViewModel)
}

class OrderShowViewController: UIViewController {
    // MARK: - Properties
    var interactor: OrderShowBusinessLogic?
    var router: (NSObjectProtocol & OrderShowRoutingLogic & OrderShowDataPassing)?
    
    var routeFrom: ShowMode = .FromSideMenu
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var cancelButton: UIButton! {
        didSet {
            cancelButton.isHidden = true
            cancelButton.setTitle(cancelButton.titleLabel!.text!.localized(), for: .normal)
        }
    }
    
    @IBOutlet var captionLabelsCollection: [SKLabel]! {
        didSet {
            _ = captionLabelsCollection.map({
                $0.text!.localize()
            })
        }
    }
    
    @IBOutlet var valuesLabelsCollection: [UILabel]! {
        didSet {
            _ = valuesLabelsCollection.map({
                $0.textAlignment = .center
            })
        }
    }
    
    @IBOutlet var headerCaptionLabelsCollection: [UILabel]! {
        didSet {
            _ = headerCaptionLabelsCollection.map({
                $0.textAlignment = .center
                $0.text = $0.text!.localized()
            })
        }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: "OrderItemsTableViewFooterView", bundle: nil), forHeaderFooterViewReuseIdentifier: "FooterCell")
            tableView.delegate = self
            tableView.dataSource = self
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
        NotificationCenter.default.removeObserver(self)
        Logger.log(message: "Success", event: .Severe)
    }
    
    
    // MARK: - Setup
    private func setup() {
        let viewController          =   self
        let interactor              =   OrderShowInteractor(AppDependency())
        let presenter               =   OrderShowPresenter()
        let router                  =   OrderShowRouter()
        
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

        self.loadViewSettings()
        
        // Add Timer Observer
        NotificationCenter.default.addObserver(self,
                                               selector:    #selector(handlerCompleteChangeOrderStatusNotification),
                                               name:        Notification.Name("CompleteChangeOrderStatus"),
                                               object:      nil)
    }
    
    override func handlerBackButtonTapped(_ sender: UIBarButtonItem) {
        if routeFrom == .FromOrderCreate {
            self.showAlertView(withTitle: "Info", andMessage: "Order accepted", needCancel: false, completion: { [unowned self] _ in
                self.navigationController?.popToRootViewController(animated: true)
            })
        }
        
        else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    // MARK: - Custom Functions
    private func loadViewSettings() {
        if let order = self.router?.dataStore?.order {
            _ = valuesLabelsCollection.first(where: { $0.tag == 2 }).map({ $0.text = order.createdDate + " " + order.collectionFrom })
            _ = valuesLabelsCollection.first(where: { $0.tag == 3 }).map({ $0.text = OrderStatus(rawValue: order.orderStatus)!.name })
            
            self.cancelButton.isHidden = (order.orderStatus != 0)
        }
    }
    
    func saveOrderID(_ orderID: Int16) {
        interactor?.saveOrderID(orderID)
    }
    
    
    // MARK: - Actions
    @IBAction func handlerCancelButtonTapped(_ sender: UIButton) {
        // API
        checkNetworkConnection({ [unowned self] success in
            if success {
                self.showAlertView(withTitle: "Info", andMessage: "Are you sure?".localized(), needCancel: true, completion: { [unowned self] success in
                    if success {
                        let requestModel = OrderShowModels.Order.RequestModel()
                        self.interactor?.cancelOrder(withRequestModel: requestModel)
                    }
                })
            }
        })
    }
    
    @objc func handlerCompleteChangeOrderStatusNotification(_ notification: Notification) {
        if let order = self.router?.dataStore?.order, order.orderStatus == 0 {
            self.navigationController?.popViewController(animated: true)
        }
        
        else {
            self.saveOrderID(self.router!.dataStore!.orderID)
            self.loadViewSettings()
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}


// MARK: - OrderShowDisplayLogic
extension OrderShowViewController: OrderShowDisplayLogic {
    func displayCancelOrder(fromViewModel viewModel: OrderShowModels.Order.ViewModel) {
        // NOTE: Display the result from the Presenter
        guard viewModel.error == nil else {
            Logger.log(message: "API 'Cancel Order' failed", event: .Info)
            self.showAlertView(withTitle: "Error", andMessage: (viewModel.error! as NSError).domain, needCancel: false, completion: {_ in})
            return
        }
        
        self.showAlertView(withTitle: "Info", andMessage: "Order status canceled".localized(), needCancel: false, completion: { _ in
            Logger.log(message: "Route to MainShow scene", event: .Info)
            self.navigationController?.popToRootViewController(animated: true)
        })
    }
}


// MARK: - UITableViewDataSource
extension OrderShowViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dataSource = self.router?.dataStore?.orderItems else {
            Logger.log(message: "Data source of DepartmentItems is empty", event: .Info)
            return 0
        }
        
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "OrderItemCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! OrderItemTableViewCell
        let orderItem = self.router!.dataStore!.orderItems![indexPath.row]
        
        cell.setup(withItem: orderItem, withOrderStatus: self.router!.dataStore!.order.orderStatus, andIndexPath: indexPath)
        
        return cell
    }
}


// MARK: - UITableViewDelegate
extension OrderShowViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54.0 * heightRatio
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 109.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if let order = self.router?.dataStore?.order {
            // Register the Nib footer section views
            let footerView = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "FooterCell") as! OrderItemsTableViewFooterView
            
            let footerViewStyle = SKStyleKit.style(withName: "sideMenuStyle")!
            footerView.contentView.backgroundColor = footerViewStyle.backgroundColor

            footerView.setup(withOrder: order)
            
            footerView.setNeedsLayout()
            footerView.layoutIfNeeded()

            let width = tableView.frame.width
            var frame = footerView.frame
            frame.size.width = width
            footerView.frame = frame

            return footerView
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
