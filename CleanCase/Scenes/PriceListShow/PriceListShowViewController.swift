//
//  PriceListShowViewController.swift
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
protocol PriceListShowDisplayLogic: class {
    func displayDepartments(fromViewModel viewModel: PriceListShowModels.Department.ViewModel)
    func displayDepartmentItems(fromViewModel viewModel: PriceListShowModels.DepartmentItems.ViewModel)
}

class PriceListShowViewController: UIViewController {
    // MARK: - Properties
    var interactor: PriceListShowBusinessLogic?
    var router: (NSObjectProtocol & PriceListShowRoutingLogic & PriceListShowDataPassing)?
    
    var widthDepartmentCell: CGFloat! = 130.0 {
        didSet {
            self.selectedView.frame.size = CGSize.init(width: self.widthDepartmentCell, height: 4.0)
        }
    }
    
    var selectedDepartmentRow: Int = 0
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var departmentItemsTableView: UITableView! {
        didSet {
            departmentItemsTableView.delegate = self
            departmentItemsTableView.dataSource = self
        }
    }
    
    @IBOutlet weak var departmentsCollectionView: UICollectionView! {
        didSet {
            departmentsCollectionView.register(UINib(nibName:               "DepartmentCollectionViewCell", bundle: nil),
                                               forCellWithReuseIdentifier:  "DepartmentCell")
            
            departmentsCollectionView.delegate = self
            departmentsCollectionView.dataSource = self
        }
    }
    
    @IBOutlet weak var selectedView: UIView!
    
    
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
        Logger.log(message: "Class deinit", event: .Severe)
    }
    
    
    // MARK: - Setup
    private func setup() {
        let viewController          =   self
        let interactor              =   PriceListShowInteractor(AppDependency())
        let presenter               =   PriceListShowPresenter()
        let router                  =   PriceListShowRouter()
        
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
    override func viewDidLayoutSubviews() {
        self.departmentsCollectionView.collectionViewLayout.invalidateLayout()

        let section                 =   0
        self.selectedDepartmentRow  =   self.departmentsCollectionView.numberOfItems(inSection: section) - 1
        let indexPath               =   IndexPath(item: self.selectedDepartmentRow, section: section)
        self.widthDepartmentCell    =   (self.departmentsCollectionView.frame.width - 30.0) / 3.0

        self.departmentsCollectionView.scrollToItem(at: indexPath, at: .right, animated: false)
        Logger.log(message: "Selected View move to new X: \(self.departmentsCollectionView.contentOffset.x)", event: .Verbose)
        self.moveSelectedView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewSettingsDidLoad()

        self.addBackBarButtonItem()
        self.addBasketBarButtonItem(true)
        self.displayLaundryInfo(withName: Laundry.name, andPhoneNumber: "\(Laundry.phoneNumber ?? "")")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.tag == 0 {
            self.moveSelectedView()
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView.tag == 0 {
            self.moveSelectedView()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.tag == 0 {
            self.moveSelectedView()
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView.tag == 0 {
            self.moveSelectedView()
        }
    }

    
    // MARK: - Custom Functions
    func viewSettingsDidLoad() {
        // API
        checkNetworkConnection({ [unowned self] success in
            if success {
                let requestModel = PriceListShowModels.Department.RequestModel()
                self.interactor?.loadDepartments(withRequestModel: requestModel)
            }
        })
    }
    
    private func moveSelectedView() {
        DispatchQueue.main.async(execute: {
            UIView.animate(withDuration: 0.1, animations: {
                self.selectedView.frame.origin = CGPoint.init(x: self.widthDepartmentCell * CGFloat(self.selectedDepartmentRow) - self.departmentsCollectionView.contentOffset.x,
                                                              y: self.selectedView.frame.minY)
            }, completion: nil)
        })
    }
}


// MARK: - PriceListShowDisplayLogic
extension PriceListShowViewController: PriceListShowDisplayLogic {
    func displayDepartments(fromViewModel viewModel: PriceListShowModels.Department.ViewModel) {
        // NOTE: Display the result from the Presenter
        let numberOfItems   =   self.departmentsCollectionView.numberOfItems(inSection: 0)
        let indexPath       =   [Int](0..<numberOfItems).map{ IndexPath(row: $0, section: 0) }
        
        self.departmentsCollectionView.reloadItems(at: indexPath)

        DispatchQueue.main.async(execute: {
            let requestModel = PriceListShowModels.DepartmentItems.RequestModel.init(selectedDepartmentRow: 0)
            self.interactor?.loadDepartmentItems(withRequestModel: requestModel)
        })
    }
    
    func displayDepartmentItems(fromViewModel viewModel: PriceListShowModels.DepartmentItems.ViewModel) {
        // NOTE: Display the result from the Presenter
        DispatchQueue.main.async(execute: {
            self.departmentItemsTableView.reloadData()
        })
    }
}


// MARK: - UITableViewDataSource
extension PriceListShowViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dataSource = self.router?.dataStore?.departmentItems else {
            Logger.log(message: "Data source of Department Items is empty", event: .Info)
            return 0
        }
        
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "DepartmentItemCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! DepartmentItemTableViewCell
        let departmentItem = self.router!.dataStore!.departmentItems[indexPath.row]
        
        cell.setup(withItem: departmentItem, andIndexPath: indexPath)
        
        return cell
    }
}


// MARK: - UITableViewDelegate
extension PriceListShowViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54.0 * heightRatio
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
    }
}


// MARK: - UICollectionViewDataSource
extension PriceListShowViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // Return the number of sections
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Return the number of items
        guard let dataSource = self.router?.dataStore?.departments else {
            Logger.log(message: "Data source of Departments is empty", event: .Info)
            return 0
        }
        
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdentifier  =   "DepartmentCell"
        let cell            =   collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! DepartmentCollectionViewCell
        let department      =   self.router!.dataStore!.departments[indexPath.row]
        
        // Config cell
        cell.setup(withItem: department, andIndexPath: indexPath)
        
        return cell
    }
}


// MARK: - UICollectionViewDelegate
extension PriceListShowViewController {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Reload departmentItems
        let requestModel = PriceListShowModels.DepartmentItems.RequestModel.init(selectedDepartmentRow: indexPath.row)
        self.interactor?.loadDepartmentItems(withRequestModel: requestModel)
        self.selectedDepartmentRow = indexPath.row
        
        self.moveSelectedView()
    }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension PriceListShowViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        self.widthDepartmentCell = (self.departmentsCollectionView.frame.width - 30.0) / 3.0

        return CGSize.init(width: self.widthDepartmentCell, height: collectionView.frame.height)
    }
}
