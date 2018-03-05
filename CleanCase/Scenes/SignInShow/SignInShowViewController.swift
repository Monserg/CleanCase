//
//  SignInShowViewController.swift
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
import M13Checkbox
import SwiftSpinner
import ADEmailAndPassword

// MARK: - Input & Output protocols
protocol SignInShowDisplayLogic: class {
    func displayClient(fromViewModel viewModel: SignInShowModels.User.ViewModel)
    func displayCities(fromViewModel viewModel: SignInShowModels.City.ViewModel)
    func initializationLaundryInfo(fromViewModel viewModel: SignInShowModels.Laundry.ViewModel)
    func initializationDeliveryDates(fromViewModel viewModel: SignInShowModels.Date.ViewModel)
    func initializationCollectionDates(fromViewModel viewModel: SignInShowModels.Date.ViewModel)
    func initializationDepartments(fromViewModel viewModel: SignInShowModels.Department.ViewModel)
}

class SignInShowViewController: UIViewController {
    // MARK: - Properties
    var interactor: SignInShowBusinessLogic?
    var router: (NSObjectProtocol & SignInShowRoutingLogic & SignInShowDataPassing)?
    
    var firstResponder: UIControl!

    
    // MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var acceptAgreementLabel: UILabel! {
        didSet {
            acceptAgreementLabel.text!.localize()
        }
    }
    
    @IBOutlet weak var readAgreementButton: UIButton! {
        didSet {
            readAgreementButton.setTitle("Read Agreement".localized(), for: .normal)
        }
    }
    
    @IBOutlet weak var saveButton: UIButton! {
        didSet {
            saveButton.isEnabled = false
            saveButton.setTitle("Save".localized(), for: .normal)
        }
    }
        
    @IBOutlet weak var acceptAgreementCheckBox: M13Checkbox! {
        didSet {
            acceptAgreementCheckBox.boxType = .square
        }
    }
    
    @IBOutlet var textFieldsCollection: [UITextField]! {
        didSet {
            _ = textFieldsCollection.map({
                $0.placeholder = router?.dataStore?.textFieldsTexts[$0.tag].placeholder
                $0.accessibilityValue = router?.dataStore?.textFieldsTexts[$0.tag].errorText
                $0.delegate = self
            })
        }
    }
    
    @IBOutlet weak var contentViewTopConstraint: NSLayoutConstraint! {
        didSet {
            contentViewTopConstraint.constant *= heightRatio
        }
    }
    
    @IBOutlet weak var scrollViewTopConstraint: NSLayoutConstraint! {
        didSet {
            scrollViewTopConstraint.constant = 0.0
        }
    }

    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer! {
        didSet {
            tapGestureRecognizer.cancelsTouchesInView = false
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
    }
    
    
    // MARK: - Setup
    private func setup() {
        let viewController          =   self
        let interactor              =   SignInShowInteractor(AppDependency())
        let presenter               =   SignInShowPresenter()
        let router                  =   SignInShowRouter()
        
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
        
        SwiftSpinner.hide()
    }
    
    
    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadViewSettings()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        Logger.log(message: "Success", event: .Severe)
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - Custom Functions
    private func loadViewSettings() {
        self.firstResponder = self.textFieldsCollection[0]
        
        // Add keyboard Observers
        self.registerForKeyboardNotifications()
        
        // API
        checkNetworkConnection({ [unowned self] success in
            if success {
                let requestModel = SignInShowModels.City.RequestModel()
                self.interactor?.fetchCities(withRequestModel: requestModel)
            }
        })
    }
    
    fileprivate func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    fileprivate func startDataValidation() {
        if let textField = textFieldsCollection.first(where: { ($0.text?.isEmpty)! }) {
            self.showAlertView(withTitle: "Info", andMessage: textField.accessibilityValue!, needCancel: false, completion: { _ in })
        }
        
        else {
            // API
            checkNetworkConnection({ [unowned self] success in
                if success {
                    self.view.isUserInteractionEnabled = false
                    
                    DispatchQueue.main.async(execute: {
                        let requestModel = SignInShowModels.Laundry.RequestModel()
                        self.interactor?.fetchLaundry(withRequestModel: requestModel)
                    })
                }
            })
        }
    }
    
    fileprivate func displayOnboardScene() {
        self.performSegue(withIdentifier: "OnboardShowSegue", sender: nil)
    }
    
    
    // MARK: - Gestures
    @IBAction func handlerTapGestureRecognizer(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    
    // MARK: - Actions
    @IBAction func handlerSaveButtonTapped(_ sender: Any) {
        self.startDataValidation()
    }
    
    @IBAction func handlerReadAgreementButtonTapped(_ sender: UIButton) {
        self.firstResponder = sender
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + dispatchTimeDelay * 3) {
            self.createPopover(withName: "AgreementShow", completion: {})
        }
    }
    
    @IBAction func handlerCheckBoxTapped(_ sender: M13Checkbox) {
        self.firstResponder         =   sender
        self.saveButton.isEnabled   =   (sender.checkState == .checked) ? true : false
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard self.firstResponder != nil else {
            return
        }

        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame  =   (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame    =   view.convert(keyboardScreenEndFrame, from: view.window)
        
        // Keyboard hide
        if notification.name == Notification.Name.UIKeyboardWillHide {
            self.scrollView.contentInset = UIEdgeInsets.zero
        }
            
        // Keyboard show
        else {
            self.scrollView.contentInset    =   UIEdgeInsets(top: 0,left: 0, bottom: keyboardViewEndFrame.height, right: 0)
            var activeViewRect              =   self.view.frame
            activeViewRect.size.height     -=   keyboardViewEndFrame.height
            
            if (!activeViewRect.contains(self.firstResponder.frame.origin)) {
                self.scrollView.scrollRectToVisible(self.firstResponder.frame, animated: true)
            }
        }
    }
}


// MARK: - SignInShowDisplayLogic
extension SignInShowViewController: SignInShowDisplayLogic {
    func displayClient(fromViewModel viewModel: SignInShowModels.User.ViewModel) {
        // NOTE: Display the result from the Presenter
        self.displayOnboardScene()
    }
    
    func displayCities(fromViewModel viewModel: SignInShowModels.City.ViewModel) {
        // NOTE: Display the result from the Presenter
        self.displayLaundryInfo(withName: "My Laundry", andPhoneNumber: nil)
    }
    
    func initializationLaundryInfo(fromViewModel viewModel: SignInShowModels.Laundry.ViewModel) {
        // API
        checkNetworkConnection({ [unowned self] success in
            if success {
                DispatchQueue.main.async(execute: {
                    SwiftSpinner.show("Initialization...".localized(), animated: true)
                    
                    let requestModel = SignInShowModels.Date.RequestModel()
                    self.interactor?.fetchCollectionDates(withRequestModel: requestModel)
                })
                
                DispatchQueue.main.async(execute: {
                    let requestModel = SignInShowModels.Date.RequestModel()
                    self.interactor?.fetchDeliveryDates(withRequestModel: requestModel)
                })
                
                DispatchQueue.main.async(execute: {
                    let requestModel = SignInShowModels.Department.RequestModel()
                    self.interactor?.fetchDepartments(withRequestModel: requestModel)
                })
            }
        })
    }
    
    func initializationDeliveryDates(fromViewModel viewModel: SignInShowModels.Date.ViewModel) {
        // NOTE: Display the result from the Presenter
    }

    func initializationCollectionDates(fromViewModel viewModel: SignInShowModels.Date.ViewModel) {
        // NOTE: Display the result from the Presenter
    }
    
    func initializationDepartments(fromViewModel viewModel: SignInShowModels.Department.ViewModel) {
        // API
        checkNetworkConnection({ [unowned self] success in
            if success {
                DispatchQueue.main.async(execute: {
                    let requestModel = SignInShowModels.User.RequestModel(params: (firstName:   self.textFieldsCollection.first(where: { $0.tag == 3})!.text!,
                                                                                   lastName:    self.textFieldsCollection.first(where: { $0.tag == 4})!.text!,
                                                                                   address:     self.textFieldsCollection.first(where: { $0.tag == 5})!.text!,
                                                                                   email:       self.textFieldsCollection.first(where: { $0.tag == 6})!.text!,
                                                                                   phone:       self.textFieldsCollection.first(where: { $0.tag == 2})!.text!))
                    
                    self.interactor?.addClient(withRequestModel: requestModel)
                })
            }
        })
    }
}


// MARK: - UITextFieldDelegate
extension SignInShowViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.firstResponder = textField
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard textField.tag != 0 && textField.tag != 1 else {
            if textField.tag == 0 {
                let selectedCityRow = (router?.dataStore?.selectedCityID == nil) ? 0 : router!.dataStore!.cities.index(where: { "\($0.id)" == router!.dataStore!.selectedCityID })
                    
                textField.showToolBar(withPickerViewDataSource: self.router!.dataStore!.cities, andSelectedItem: selectedCityRow!, { [unowned self] row in
                    if let selectedRow = row as? Int {
                        self.interactor?.saveSelectedCity(byRow: selectedRow)
                        textField.text = self.router!.dataStore!.cities[selectedRow].title
                    }
                    
                    textField.resignFirstResponder()
                })
            }

            else if textField.tag == 1 {
                let selectedCodeRow = (router?.dataStore?.selectedPhoneCode == nil) ? 0 : router!.dataStore!.codes.index(where: { $0.title == router!.dataStore!.selectedPhoneCode })
                
                textField.showToolBar(withPickerViewDataSource: self.router!.dataStore!.codes, andSelectedItem: selectedCodeRow!, { [unowned self] row in
                    if let selectedRow = row as? Int {
                        self.interactor?.saveSelectedPhoneCode(byRow: selectedRow)
                        textField.text = self.router!.dataStore!.codes[selectedRow].title
                    }
                    
                    textField.resignFirstResponder()
                })
            }

            return true
        }
        
        return true
    }
    
    // Clear button tap
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    // Hide keyboard
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.firstResponder = nil
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        // Phone number
//        if textField.tag == 2 {
//            if let phoneNumber = textField.text, phoneNumber.count < 7 {
//                self.showAlertView(withTitle: "Info", andMessage: "Please, enter correct phone number...", needCancel: false, completion: {_ in})
//                return false
//            }
//        }

        if textField.tag == 6 {
            if let email = textField.text, !email.isEmpty {
                guard ADEmailAndPassword.validateEmail(emailId: email) else {
                    self.showAlertView(withTitle: "Error", andMessage: "Please, enter correct email...", needCancel: false, completion: { _ in })
                    return false
                }
                
                return true
            }
        }
        
        return true
    }
    
    // TextField editing
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField.tag {
        case 2:
            guard !string.isEmpty else { return true }
            return (textField.text!.count + string.count) < 8 && CharacterSet.decimalDigits.contains(Unicode.Scalar(string)!)

        case 3, 4:
            return (textField.text!.count + string.count) < 21

        case 5, 6:
            return (textField.text!.count + string.count) < 51

        default:
            return true
        }
    }
    
    // Return button tap
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 6 {
            textField.resignFirstResponder()
        }
        
        else {
            textFieldsCollection.first(where: { $0.tag == textField.tag + 1 })?.becomeFirstResponder()
        }
        
        return true
    }
}
