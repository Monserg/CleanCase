//
//  WriteUsShowViewController.swift
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

// MARK: - Input & Output protocols
protocol WriteUsShowDisplayLogic: class {
    func displaySendMessage(fromViewModel viewModel: WriteUsShowModels.Data.ViewModel)
}

class WriteUsShowViewController: UIViewController {
    // MARK: - Properties
    var interactor: WriteUsShowBusinessLogic?
    var router: (NSObjectProtocol & WriteUsShowRoutingLogic & WriteUsShowDataPassing)?
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var sendMessageButton: UIButton! {
        didSet {
            sendMessageButton.isEnabled = false
        }
    }

    @IBOutlet weak var charactersCountLabel: UILabel! {
        didSet {
            charactersCountLabel.text = "0/200"
        }
    }
    
    @IBOutlet weak var textView: UITextView! {
        didSet {
            textView.text = "Enter message".localized()
            textView.layer.borderColor = UIColor.black.cgColor
            textView.layer.borderWidth = 1
            textView.layer.cornerRadius = 4
            textView.delegate = self
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
        let interactor              =   WriteUsShowInteractor(AppDependency())
        let presenter               =   WriteUsShowPresenter()
        let router                  =   WriteUsShowRouter()
        
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
    
    
    // MARK: - Custom Functions
    fileprivate func loadTextViewPlaceholder(_ text: String?) {
        if (text == nil) {
            textView.text = ""
//            textView.font = UIFont.ubuntuLight12
            textView.textColor = UIColor.black
            sendMessageButton.isEnabled = false
        } else if (text == "Enter message".localized() || text!.isEmpty) {
            textView.text = "Enter message".localized()
//            textView.font = UIFont.ubuntuLightItalic12
            textView.textColor = UIColor.green
            sendMessageButton.isEnabled = false
        } else {
//            commentTextView.font = UIFont.ubuntuLight12
            textView.textColor = UIColor.blue
            sendMessageButton.isEnabled = true
        }
    }
    
    
    // MARK: - Gestures
    @IBAction func handlerTapGestureRecognizer(_ sender: UITapGestureRecognizer) {
        textView.resignFirstResponder()
    }
    
    
    // MARK: - Actions
    @IBAction func handlerSendMessageButtonTapped(_ sender: UIButton) {
        let requestModel = WriteUsShowModels.Data.RequestModel(message: textView.text)
        interactor?.sendMessage(withRequestModel: requestModel)
    }
}


// MARK: - WriteUsShowDisplayLogic
extension WriteUsShowViewController: WriteUsShowDisplayLogic {
    func displaySendMessage(fromViewModel viewModel: WriteUsShowModels.Data.ViewModel) {
        // NOTE: Display the result from the Presenter
        guard viewModel.error == nil else {
            self.showAlertView(withTitle: "Errord", andMessage: viewModel.error!.localizedDescription, needCancel: false, completion: { _ in })
            return
        }
        
        self.showAlertView(withTitle: "Info", andMessage: "Message sent", needCancel: false, completion: { [unowned self] success in
            self.navigationController?.popViewController(animated: true)
        })
    }
}


// MARK: -
extension WriteUsShowViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        loadTextViewPlaceholder((textView.text == "Enter message".localized()) ? nil : textView.text)
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        loadTextViewPlaceholder(textView.text)
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        charactersCountLabel.text = "\(textView.text!.count + text.count)/200"
        
        return (textView.text!.count + text.count) < 200
    }
}
