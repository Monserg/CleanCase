//
//  OrderCreateViewController.swift
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
import DynamicColor
import SwiftSpinner

// MARK: - Input & Output protocols
protocol OrderCreateDisplayLogic: class {
    func displayDates(fromViewModel viewModel: OrderCreateModels.Dates.ViewModel)
    func displayAddOrder(fromViewModel viewModel: OrderCreateModels.Order.ViewModel)
    func displayDepartments(fromViewModel viewModel: OrderCreateModels.Departments.ViewModel)
}

class OrderCreateViewController: UIViewController {
    // MARK: - Properties
    var interactor: OrderCreateBusinessLogic?
    var router: (NSObjectProtocol & OrderCreateRoutingLogic & OrderCreateDataPassing)?
    
    var firstResponder: UITextInput!
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet var labelsCollection: [UILabel]! {
        didSet {
            _ = labelsCollection.map({
                $0.text?.localize()
                $0.textAlignment = .right
            })
        }
    }
    
    @IBOutlet var textFieldsCollection: [UITextField]! {
        didSet {
            _ = textFieldsCollection.map({
                $0.placeholder          =   router?.dataStore?.textFieldsTexts[$0.tag].placeholder
                $0.accessibilityValue   =   router?.dataStore?.textFieldsTexts[$0.tag].errorText
               
                $0.addPadding(.Both(8.0))
                
                $0.delegate = self
            })
        }
    }

    @IBOutlet var textViewCollection: [UITextView]! {
        didSet {
            _ = textViewCollection.map({
                $0.text!.localize()
                $0.backgroundColor      =   DynamicColor(hexString: "#82FFFF")              // veryLightCyan
                $0.layer.borderColor    =   DynamicColor(hexString: "#A9A9A9").cgColor      // gray
                $0.layer.borderWidth    =   1
                $0.layer.cornerRadius   =   4
                $0.font                 =   UIFont.systemFont(ofSize: 16.0)
                $0.textAlignment        =   .right
                $0.textColor            =   DynamicColor(hexString: "#A9A9A9")              // gray
                $0.tintColor            =   DynamicColor(hexString: "#000000")              // black
                $0.contentInset         =   UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 8.0)
                
                $0.delegate = self
            })
        }
    }
    
    @IBOutlet weak var saveButton: UIButton! {
        didSet {
            saveButton.isEnabled = false
        }
    }
    
    @IBOutlet weak var departmentsTableView: UITableView! {
        didSet {
            departmentsTableView.delegate = self
            departmentsTableView.dataSource = self
        }
    }
    
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer! {
        didSet {
            tapGestureRecognizer.cancelsTouchesInView = false
        }
    }
    
    @IBOutlet weak var departmentsTableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var scrollViewTopConstraint: NSLayoutConstraint! {
        didSet {
            scrollViewTopConstraint.constant = smallDevices.contains(UIDevice.current.deviceType) ? -64.0 : 0.0
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
        let interactor              =   OrderCreateInteractor(AppDependency())
        let presenter               =   OrderCreatePresenter()
        let router                  =   OrderCreateRouter()
        
        viewController.interactor   =   interactor
        viewController.router       =   router
        interactor.presenter        =   presenter
        presenter.viewController    =   viewController
        router.viewController       =   viewController
        router.dataStore            =   interactor
    }
    
    
    // MARK: - Routing
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Prepare body parameters of API 'Add Order'
        if segue.identifier == "PersonalDataShowSegue" {
            let destinationVC = segue.destination as! PersonalDataShowViewController
            destinationVC.routeFrom = .FromOrderCreate
        }
        
        else if segue.identifier == "OrderShowSegue" {
            let destinationVC = segue.destination as! OrderShowViewController
            destinationVC.routeFrom = .FromOrderCreate
            destinationVC.saveOrderID(Int16(self.router!.dataStore!.orderID!)!)
        }

        self.view.isUserInteractionEnabled = true
    }
    
    
    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addBackBarButtonItem()
        self.displayLaundryInfo(withName: Laundry.name, andPhoneNumber: "\(Laundry.phoneNumber ?? "")")
        
        loadVewSettings()
    }
    
    
    // MARK: - Custom Functions
    func loadVewSettings() {
        // Add keyboard Observers
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillHide, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        // API
        checkNetworkConnection({ [unowned self] success in
            if success {
                DispatchQueue.main.async(execute: {
                    let requestModel = OrderCreateModels.Departments.RequestModel()
                    self.interactor?.fetchDepartments(withRequestModel: requestModel)
                })
                
                DispatchQueue.main.async(execute: {
                    let requestModel = OrderCreateModels.Dates.RequestModel()
                    self.interactor?.fetchDates(withRequestModel: requestModel)
                })
            }
        })
    }
    
    fileprivate func startDataValidation() {
        if let textField = textFieldsCollection.first(where: { ($0.text?.isEmpty)! }) {
            self.showAlertView(withTitle: "Info", andMessage: textField.accessibilityValue!, needCancel: false, completion: { _ in })
        }
        
        else {
            // API
            checkNetworkConnection({ [unowned self] success in
                if success {
                    SwiftSpinner.show("Add Order...".localized(), animated: true)
                    
                    DispatchQueue.main.async(execute: {
                        self.view.isUserInteractionEnabled = false
                        let requestModel = OrderCreateModels.Order.RequestModel(bodyParams: self.prepareBodyParameters(true) as! [String : [String : Any]])
                        self.interactor?.addOrder(withRequestModel: requestModel)
                    })
                }
            })
        }
    }
    
    fileprivate func prepareBodyParameters(_ forAPI: Bool) -> [ String: Any ] {
        var comments = textViewCollection.first(where: { $0.tag == 0 })?.text
        var instructions = textViewCollection.first(where: { $0.tag == 1 })?.text
        let selectedDepartments = self.router!.dataStore!.departments.filter({ $0.isSelected }).reduce("") { $0 + " ," + $1.name }

        if comments == "Enter comment".localized() {
            comments = selectedDepartments
        }
        
        else {
            comments! += selectedDepartments
        }

        if instructions == "Enter cleaning instructions".localized() {
            instructions = selectedDepartments
        }
        
        else {
            instructions! += selectedDepartments
        }

        let collectionTimeFrom  =   (self.router!.dataStore!.times[self.router!.dataStore!.selectedTimeRow] as! OrderCreateModels.Dates.RequestModel.TimeForPickerView).bodyTimeFrom
        let collectionTimeTo    =   (self.router!.dataStore!.times[self.router!.dataStore!.selectedTimeRow] as! OrderCreateModels.Dates.RequestModel.TimeForPickerView).bodyTimeTo
        let createdDate         =   (self.router!.dataStore!.times[self.router!.dataStore!.selectedTimeRow] as! OrderCreateModels.Dates.RequestModel.TimeForPickerView).bodyDate

        var bodyParams: [ String: Any ] =   [
                                                "ClientId":                 PersonalData.current!.clientId,
                                                "CleaningInstructions":     instructions!,
                                                "Remarks":                  comments!,
                                                "CollectionFrom":           createdDate + " " + collectionTimeFrom,
                                                "Price":                    Float(0)
                                            ]
        guard forAPI == false else {
            return [ "order": bodyParams ]
        }
        
        bodyParams["OrderID"]           =   self.router!.dataStore!.orderID
        bodyParams["OrderStatus"]       =   0
        bodyParams["Address1"]          =   textFieldsCollection.first(where: { $0.tag == 0 })!.text!


        bodyParams["CollectionFrom"]    =   collectionTimeFrom
        bodyParams["CollectionTo"]      =   collectionTimeTo
        bodyParams["CreatedDate"]       =   createdDate

        return bodyParams
    }
    
    fileprivate func loadTextViewPlaceholder(_ text: String?, _ tag: Int) {
        if (text == nil) {
            _ = textViewCollection.first(where: { $0.tag == tag }).map({
                $0.text         =   ""
                $0.textColor    =   DynamicColor(hexString: "#000000")              // black
            })
        }
        
        else if (text == "Enter comment".localized() || (text!.isEmpty && tag == 0)) {
            _ = textViewCollection.first(where: { $0.tag == 0 }).map({
                $0.text         =   "Enter comment".localized()
                $0.textColor    =   DynamicColor(hexString: "#A9A9A9")              // gray
            })
        }
        
        else if (text == "Enter cleaning instructions".localized() || (text!.isEmpty && tag == 1)) {
            _ = textViewCollection.first(where: { $0.tag == 1 }).map({
                $0.text         =   "Enter cleaning instructions".localized()
                $0.textColor    =   DynamicColor(hexString: "#A9A9A9")              // gray
            })
        }
        
        else {
            _ = textViewCollection.first(where: { $0.tag == tag }).map({
                $0.textColor    =   DynamicColor(hexString: "#000000")              // black
            })
        }
    }
    
    
    // MARK: - Gestures
    @IBAction func handlerTapGestureRecognizer(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    
    // MARK: - Actions
    @IBAction func handlerSaveButtonTapped(_ sender: UIButton) {
        self.startDataValidation()
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == Notification.Name.UIKeyboardWillHide {
            self.scrollView.contentInset = UIEdgeInsets.zero
        }
        
        else {
            self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
    }
}


// MARK: - OrderCreateDisplayLogic
extension OrderCreateViewController: OrderCreateDisplayLogic {
    func displayDates(fromViewModel viewModel: OrderCreateModels.Dates.ViewModel) {
        // NOTE: Display the result from the Presenter
    }

    func displayAddOrder(fromViewModel viewModel: OrderCreateModels.Order.ViewModel) {
        // NOTE: Display the result from the Presenter
        self.view.isUserInteractionEnabled = true

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + dispatchTimeDelay * 17) {
            SwiftSpinner.hide()
            
            guard viewModel.error == nil else {
                self.showAlertView(withTitle: "Error", andMessage: (viewModel.error! as NSError).domain, needCancel: false, completion: {_ in})
                return
            }

            self.interactor?.saveOrder(fromJSON: self.prepareBodyParameters(false))
            
            self.showAlertView(withTitle: "Info", andMessage: "Order added", needCancel: false, completion: {_ in
                if let personalDataEntity = PersonalData.current, personalDataEntity.cardNumber!.isEmpty {
                    self.performSegue(withIdentifier: "PersonalDataShowSegue", sender: nil)
                }
                    
                else {
                    self.performSegue(withIdentifier: "OrderShowSegue", sender: nil)
                }
            })
        }
    }

    func displayDepartments(fromViewModel viewModel: OrderCreateModels.Departments.ViewModel) {
        // NOTE: Display the result from the Presenter
        DispatchQueue.main.async(execute: {
            self.departmentsTableViewHeightConstraint.constant += CGFloat(self.router!.dataStore!.departments.count - 1) * 54.0 * heightRatio + 4.0
            self.departmentsTableView.reloadData()
        })
    }
}


// MARK: - UITextFieldDelegate
extension OrderCreateViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 1 {
            textField.showToolBar(withPickerViewDataSource: self.router!.dataStore!.dates, andSelectedItem: router!.dataStore!.selectedDateRow, { [unowned self] row in
                if let selectedRow = row as? Int {
                    self.interactor?.saveSelectedDate(byRow: selectedRow)
                    textField.text = self.router!.dataStore!.dates[selectedRow].title
                    
                    self.textFieldsCollection.first(where: { $0.tag == 2 }).map({
                        $0.text = nil
                        $0.isEnabled = true
                    })
                    
                    self.interactor?.saveSelectedTime(byRow: 0)
                }
                
                textField.resignFirstResponder()
            })
        }
            
        else if textField.tag == 2 {
            textField.showToolBar(withPickerViewDataSource: self.router!.dataStore!.times, andSelectedItem: router!.dataStore!.selectedTimeRow, { [unowned self] row in
                if let selectedRow = row as? Int {
                    self.interactor?.saveSelectedTime(byRow: selectedRow)
                    textField.text = self.router!.dataStore!.times[selectedRow].title
                }
                
                textField.resignFirstResponder()
            })
        }
        
        return true
    }
    
    // Clear button tap
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    // Hide keyboard
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    // TextField editing
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Address
        if textField.tag == 0 {
            return (textField.text!.count + string.count) < 51
        }
        
        return true
    }
    
    // Return button tap
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            _ = textViewCollection.first(where: { $0.tag == 0 })?.becomeFirstResponder()
        }
        
        return true
    }
}


// MARK: - UITextViewDelegate
extension OrderCreateViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.firstResponder = textView
        
        if textView.tag == 0 {
            loadTextViewPlaceholder((textView.text == "Enter comment".localized()) ? nil : textView.text, 0)
        }
        
        else {
            loadTextViewPlaceholder((textView.text == "Enter cleaning instructions".localized()) ? nil : textView.text, 1)
        }
        
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        loadTextViewPlaceholder(textView.text, textView.tag)
        
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return (textView.text!.count + text.count) < 100
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.hasPrefix("\n") {
            textView.text = String(textView.text.filter({ !"\n".contains($0) }))
        }
    }
}


// MARK: - UITableViewDataSource
extension OrderCreateViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dataSource = self.router?.dataStore?.departments else {
            return 0
        }
        
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "DepartmentCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! DepartmentTableViewCell
        let department = self.router!.dataStore!.departments[indexPath.row]
        
        cell.setup(withItem: department, andIndexPath: indexPath)
        
        return cell
    }
}


// MARK: - UITableViewDelegate
extension OrderCreateViewController: UITableViewDelegate {
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
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
            }
                
            else {
                cell.accessoryType = .checkmark
            }
            
            self.interactor?.updateDepartment(selectedState: cell.accessoryType, byRow: indexPath.row)
            self.saveButton.isEnabled = self.router!.dataStore!.departments.filter({ $0.isSelected == true }).count > 0
        }
    }
}

