//
//  DeliveryTermsShowViewController.swift
//  CleanCase
//
//  Created by msm72 on 08.02.2018.
//  Copyright (c) 2018 msm72. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import SKStyleKit
import DynamicColor

// MARK: - Input & Output protocols
protocol DeliveryTermsShowDisplayLogic: class {
    func displayData(fromViewModel viewModel: DeliveryTermsShowModels.Dates.ViewModel)
    func displayConfirmDeliveryTerms(fromViewModel viewModel: DeliveryTermsShowModels.Item.ViewModel)
}

class DeliveryTermsShowViewController: SharePopoverViewController {
    // MARK: - Properties
    var interactor: DeliveryTermsShowBusinessLogic?
    var router: (NSObjectProtocol & DeliveryTermsShowRoutingLogic & DeliveryTermsShowDataPassing)?
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bottomView: SKView!
    
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer! {
        didSet {
            tapGestureRecognizer.cancelsTouchesInView = false
        }
    }

    @IBOutlet var viewsHeightConstraintCollection: [NSLayoutConstraint]! {
        didSet {
            _ = viewsHeightConstraintCollection.map({
                $0.constant *= heightRatio
            })
        }
    }
    
    @IBOutlet var viewsCollection: [UIView]! {
        didSet {
            _ = viewsCollection.map({
                $0.layer.cornerRadius   =   4.0
                $0.clipsToBounds        =   true
            })
        }
    }
    
    @IBOutlet weak var notificationTimeLabel: SKLabel! {
        didSet {
            notificationTimeLabel.text = Date().getCurrentTime()
        }
    }
    
    @IBOutlet weak var notificationTitleLabel: SKLabel! {
        didSet {
            notificationTitleLabel.text!.localize()
        }
    }
    
    @IBOutlet weak var notificationMessageLabel: SKLabel! {
        didSet {
            notificationMessageLabel.text = Laundry.name + notificationMessageLabel.text!.localized()
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text!.localize()
            titleLabel.textAlignment = .right
            titleLabel.numberOfLines = 1
        }
    }
    
    @IBOutlet weak var captionLabel: UILabel! {
        didSet {
            captionLabel.text!.localize()
            captionLabel.textAlignment = .center
            captionLabel.numberOfLines = 0
        }
    }
    
    @IBOutlet var textFieldsCollection: [UITextField]! {
        didSet {
            _ = textFieldsCollection.map({
                $0.placeholder = router?.dataStore?.textFieldsTexts[$0.tag].placeholder
                $0.accessibilityValue = router?.dataStore?.textFieldsTexts[$0.tag].errorText
                
                $0.addPadding(.Both(8.0))

                $0.delegate = self
            })
        }
    }
    
    @IBOutlet weak var charactersCountLabel: UILabel! {
        didSet {
            charactersCountLabel.text = "0/100"
        }
    }
    
    @IBOutlet weak var textView: UITextView! {
        didSet {
            textView.text!.localize()
            textView.backgroundColor      =   DynamicColor(hexString: "#82FFFF")              // veryLightCyan
            textView.layer.borderColor    =   DynamicColor(hexString: "#A9A9A9").cgColor      // gray
            textView.layer.borderWidth    =   1
            textView.layer.cornerRadius   =   4
            textView.font                 =   UIFont.systemFont(ofSize: 16.0)
            textView.textAlignment        =   .right
            textView.textColor            =   DynamicColor(hexString: "#A9A9A9")              // gray
            textView.tintColor            =   DynamicColor(hexString: "#000000")              // black
            textView.contentInset         =   UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 8.0)
            
            textView.delegate = self
        }
    }
    
    @IBOutlet weak var saveButton: UIButton! {
        didSet {
            saveButton.isEnabled = false
        }
    }
    
    @IBOutlet weak var circularImageView: SKView! {
        didSet {
            circularImageView.layer.cornerRadius = circularImageView.bounds.height / 2
            circularImageView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var bellImageView: UIImageView! {
        didSet {
            bellImageView.layer.cornerRadius = 4.0
            bellImageView.clipsToBounds = true
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
        let interactor              =   DeliveryTermsShowInteractor(AppDependency())
        let presenter               =   DeliveryTermsShowPresenter()
        let router                  =   DeliveryTermsShowRouter()
        
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
        
        loadViewSettings()
    }
    
    
    // MARK: - Custom Functions
    func loadViewSettings() {
        // Add keyboard Observers
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillHide, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        // API
        checkNetworkConnection({ [unowned self] success in
            if success {
                DispatchQueue.main.async(execute: {
                    let requestModel = DeliveryTermsShowModels.Dates.RequestModel()
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
            self.view.isUserInteractionEnabled = false
            
            // API
            checkNetworkConnection({ [unowned self] success in
                if success {
                    DispatchQueue.main.async(execute: {
                        let requestModel = DeliveryTermsShowModels.Item.RequestModel(comment: self.textView.text)
                        self.interactor?.confirmDeliveryTerms(withRequestModel: requestModel)
                    })
                }
            })
        }
    }
    
    fileprivate func loadTextViewPlaceholder(_ text: String?) {
        if (text == nil) {
            textView.text       =   ""
            textView.textColor  =   DynamicColor(hexString: "#000000")              // black
        }
        
        else if (text == "Enter comment".localized() || text!.isEmpty) {
            textView.text       =   "Enter comment".localized()
            textView.textColor  =   DynamicColor(hexString: "#A9A9A9")              // gray
        }
        
        else {
            textView.textColor  =   DynamicColor(hexString: "#000000")              // black
        }
    }
    
    
    // MARK: - Gestures
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if (touch.view == self.view) {
                self.dismiss(animated: true, completion: { [unowned self] in
                    self.handlerDismissCompletion()
                })
            }
                
            else {
                self.textView.resignFirstResponder()
            }
        }
    }
    
    
    // MARK: - Actions
    @IBAction func handlerSaveButtonTapped(_ sender: UIButton) {
        self.startDataValidation()
    }
    
    @IBAction func handlerTapGestureRecognizer(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    @objc func adjustForKeyboard(notification: Notification) {
        if textView.isFirstResponder {
            let userInfo = notification.userInfo!
            
            let keyboardScreenEndFrame  =   (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            let keyboardViewEndFrame    =   view.convert(keyboardScreenEndFrame, from: view.window)
            
            if notification.name == Notification.Name.UIKeyboardWillHide {
                self.scrollView.setContentOffset(.zero, animated: true)
            }
                
            else {
                let textViewFrame       =   view.convert(textView.frame, from: bottomView)
                self.scrollView.setContentOffset(CGPoint.init(x: 0, y: textViewFrame.maxY + 10.0 - keyboardViewEndFrame.minY), animated: true)
            }
        }
    }
}


// MARK: - DeliveryTermsShowDisplayLogic
extension DeliveryTermsShowViewController: DeliveryTermsShowDisplayLogic {
    func displayData(fromViewModel viewModel: DeliveryTermsShowModels.Dates.ViewModel) {
        // NOTE: Display the result from the Presenter
    }
    
    func displayConfirmDeliveryTerms(fromViewModel viewModel: DeliveryTermsShowModels.Item.ViewModel) {
        // NOTE: Display the result from the Presenter
        guard viewModel.error == nil else {
            self.showAlertView(withTitle: "Error", andMessage: viewModel.error!.localizedDescription, needCancel: false, completion: { _ in })
            self.view.isUserInteractionEnabled = false
            return
        }
        
        self.showAlertView(withTitle: "Info", andMessage: "Order confirmed", needCancel: false, completion: { [unowned self] success in
            self.dismiss(animated: true, completion: { [unowned self] in
                self.handlerDismissCompletion()
            })
        })
    }
}


// MARK: - UITextFieldDelegate
extension DeliveryTermsShowViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            textField.showToolBar(withPickerViewDataSource: self.router!.dataStore!.dates, andSelectedItem: router!.dataStore!.selectedDateRow, { [unowned self] row in
                if let selectedRow = row as? Int {
                    self.interactor?.saveSelectedDate(byRow: selectedRow)
                    textField.text = self.router!.dataStore!.dates[selectedRow].title
                    
                    self.saveButton.isEnabled = false
                    self.textFieldsCollection.first(where: { $0.tag == 1 }).map({
                        $0.text = nil
                        $0.isEnabled = true
                    })
                    
                    self.interactor?.saveSelectedTime(byRow: 0)
                }
                
                textField.resignFirstResponder()
            })
        }
            
        else if textField.tag == 1 {
            textField.showToolBar(withPickerViewDataSource: self.router!.dataStore!.times, andSelectedItem: router!.dataStore!.selectedTimeRow, { [unowned self] row in
                if let selectedRow = row as? Int {
                    self.interactor?.saveSelectedTime(byRow: selectedRow)
                    textField.text = self.router!.dataStore!.times[selectedRow].title
                    
                    self.saveButton.isEnabled = true
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
        return true
    }
    
    // Return button tap
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}


// MARK: - UITextViewDelegate
extension DeliveryTermsShowViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        loadTextViewPlaceholder((textView.text == "Enter comment".localized()) ? nil : textView.text)
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        loadTextViewPlaceholder(textView.text)
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        charactersCountLabel.text = "\(textView.text!.count + text.count)/100"

        return (textView.text!.count + text.count) < 100
    }
}
