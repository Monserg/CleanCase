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
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var saveButton: UIButton! {
        didSet {
            saveButton.isEnabled = false
        }
    }
        
    @IBOutlet weak var acceptAgreementCheckBox: M13Checkbox! {
        didSet {
            acceptAgreementCheckBox.boxType = .square
        }
    }
    
    
    @IBOutlet weak var acceptAgreementLabel: UILabel!
    @IBOutlet weak var readAgreementButton: UIButton!
    
    @IBOutlet var textFieldsCollection: [UITextField]! {
        didSet {
            _ = textFieldsCollection.map({
                $0.placeholder = router?.dataStore?.textFieldsTexts[$0.tag].placeholder
                $0.accessibilityValue = router?.dataStore?.textFieldsTexts[$0.tag].errorText
                $0.backgroundColor = .red
                $0.delegate = self
            })
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
        
        viewSettingsDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    
    // MARK: - Custom Functions
    func viewSettingsDidLoad() {
        let requestModel = SignInShowModels.City.RequestModel()
        interactor?.fetchCities(withRequestModel: requestModel)
    }
    
    fileprivate func startDataValidation() {
        if let textField = textFieldsCollection.first(where: { ($0.text?.isEmpty)! }) {
            self.showAlertView(withTitle: "Info", andMessage: textField.accessibilityValue!, needCancel: false, completion: { _ in })
        }
        
        else {
            self.view.isUserInteractionEnabled = false
            
            DispatchQueue.main.async(execute: {
                let requestModel = SignInShowModels.Laundry.RequestModel()
                self.interactor?.fetchLaundry(withRequestModel: requestModel)
            })
        }
    }
    
    fileprivate func displayOnboardScene() {
        self.performSegue(withIdentifier: "OnboardShowSegue", sender: nil)
    }
    
    
    // MARK: - Gestures
    @IBAction func handlerTapGestureRecognizer(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    
    // MARK: - Actions
    @IBAction func handlerSaveButtonTapped(_ sender: Any) {
        self.startDataValidation()
    }
    
    @IBAction func handlerReadAgreementButtonTapped(_ sender: Any) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + dispatchTimeDelay * 3) {
            self.createPopover(withName: "AgreementShow")
        }
    }
    
    @IBAction func handlerCheckBoxTapped(_ sender: M13Checkbox) {
        self.saveButton.isEnabled = (sender.checkState == .checked) ? true : false
    }
}


// MARK: - SignInShowDisplayLogic
extension SignInShowViewController: SignInShowDisplayLogic {
    func displayCities(fromViewModel viewModel: SignInShowModels.City.ViewModel) {
        // NOTE: Display the result from the Presenter
        self.displayLaundryInfo(withName: "My Laundry", andPhoneNumber: nil)
    }
    
    func initializationLaundryInfo(fromViewModel viewModel: SignInShowModels.Laundry.ViewModel) {
        // NOTE: Display the result from the Presenter
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
    
    func initializationDeliveryDates(fromViewModel viewModel: SignInShowModels.Date.ViewModel) {
        // NOTE: Display the result from the Presenter
    }

    func initializationCollectionDates(fromViewModel viewModel: SignInShowModels.Date.ViewModel) {
        // NOTE: Display the result from the Presenter
    }
    
    func initializationDepartments(fromViewModel viewModel: SignInShowModels.Department.ViewModel) {
        // NOTE: Display the result from the Presenter
        self.displayOnboardScene()
    }
}


// MARK: - UITextFieldDelegate
extension SignInShowViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard textField.tag != 0 && textField.tag != 1 else {
            if textField.tag == 0 {
                let selectedCityRow = (router?.dataStore?.selectedCityID == nil) ? 0 : router!.dataStore!.cities.index(where: { $0.id == router!.dataStore!.selectedCityID })
                    
                textField.showToolBar(withPickerViewDataSource: self.router!.dataStore!.cities, andSelectedItem: selectedCityRow!, { [unowned self] city in
                    if let selectedCity = city as? PickerViewSupport {
                        textField.text = selectedCity.title
                        self.interactor?.saveSelectedCityID(selectedCity.id)
                    }
                    
                    textField.resignFirstResponder()
                })
            }

            else if textField.tag == 1 {
                let selectedCodeRow = (router?.dataStore?.selectedCodeTitle == nil) ? 0 : router!.dataStore!.codes.index(where: { $0.title == router!.dataStore!.selectedCodeTitle })
                
                textField.showToolBar(withPickerViewDataSource: self.router!.dataStore!.codes, andSelectedItem: selectedCodeRow!, { [unowned self] code in
                    if let selectedCode = code as? PickerViewSupport {
                        textField.text = selectedCode.title
                        self.interactor?.saveSelectedCodeTitle(selectedCode.title)
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
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
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
        } else {
            textFieldsCollection.first(where: { $0.tag == textField.tag + 1 })?.becomeFirstResponder()
        }
        
        return true
    }
}
