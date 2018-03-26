//
//  ChatShowViewController.swift
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
protocol ChatShowDisplayLogic: class {
    func displayMessages(fromViewModel viewModel: ChatShowModels.Message.ViewModel)
    func displaySendMessage(fromViewModel viewModel: ChatShowModels.Message.ViewModel)
}

class ChatShowViewController: UIViewController, RefreshDataSupport {
    // MARK: - Properties
    var interactor: ChatShowBusinessLogic?
    var router: (NSObjectProtocol & ChatShowRoutingLogic & ChatShowDataPassing)?
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate      =   self
            tableView.dataSource    =   self

            // Set automatic dimensions for row height
            tableView.rowHeight             =   UITableViewAutomaticDimension
            tableView.estimatedRowHeight    =   UITableViewAutomaticDimension
        }
    }

    @IBOutlet weak var textView: UITextView! {
        didSet {
            textView.text!.localize()
            textView.backgroundColor        =   DynamicColor(hexString: "#82FFFF")              // veryLightCyan
            textView.layer.borderColor      =   DynamicColor(hexString: "#A9A9A9").cgColor      // gray
            textView.layer.borderWidth      =   1
            textView.layer.cornerRadius     =   4
            textView.font                   =   UIFont.systemFont(ofSize: 16.0)
            textView.textAlignment          =   .right
            textView.textColor              =   DynamicColor(hexString: "#A9A9A9")              // gray
            textView.tintColor              =   DynamicColor(hexString: "#000000")              // black
            textView.textContainerInset     =   UIEdgeInsets(top: 4.0, left: 1.0, bottom: 4.0, right: 4.0)
            
            textView.delegate   =   self
        }
    }

    @IBOutlet weak var sendMessageButton: UIButton! {
        didSet {
            sendMessageButton.showsTouchWhenHighlighted   =   true
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
        let interactor              =   ChatShowInteractor(AppDependency())
        let presenter               =   ChatShowPresenter()
        let router                  =   ChatShowRouter()
        
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
        
        // Add Timer Observer
        NotificationCenter.default.addObserver(self,
                                               selector:    #selector(handlerCompleteReceiveNewMessageNotification),
                                               name:        Notification.Name("CompleteReceiveNewMessage"),
                                               object:      nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.refreshData()
    }
    
    // RefreshDataSupport protocol implementation
    func refreshData() {
        self.loadViewSettings()
    }

    
    // MARK: - Custom Functions
    private func loadViewSettings() {
        self.textView.text          =   "Enter message".localized()
        textView.textColor          =   DynamicColor(hexString: "#A9A9A9")              // gray

        // CoreData
        let requestModel = ChatShowModels.Message.RequestModel()
        interactor?.loadMessages(withRequestModel: requestModel)
    }
    
    fileprivate func loadTextViewPlaceholder(_ text: String?) {
        guard text != nil else {
            textView.text           =   ""
            textView.textColor      =   DynamicColor(hexString: "#000000")              // black
            return
        }
        
        if (text!.isEmpty) {
            textView.text           =   "Enter message".localized()
            textView.textColor      =   DynamicColor(hexString: "#A9A9A9")              // gray
        }
            
        else if text == "Enter message".localized() {
            textView.text           =   ""
            textView.textColor      =   DynamicColor(hexString: "#A9A9A9")              // gray
        }
            
        else {
            textView.textColor      =   DynamicColor(hexString: "#000000")              // black
        }
    }

    
    // MARK: - Gestures
    @IBAction func handlerTapGestureOnTableView(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
        
        // Scroll UITextView
        textView.scrollRangeToVisible(NSMakeRange(0, 0))
    }
    
    
    // MARK: - Actions
    @objc func handlerCompleteReceiveNewMessageNotification(_ notification: Notification) {
        // Redraw ChatShow scene
        self.refreshData()
    }

    @IBAction func handlerSendMessageButtonTapped(_ sender: UIButton) {
        if let text = self.textView.text, text.count > 0, text != "Enter message".localized() {
            // API
            checkNetworkConnection({ [unowned self] success in
                if success {
                    let requestModel = ChatShowModels.Message.RequestModel(message: text)
                    self.interactor?.sendMessage(withRequestModel: requestModel)
                }
            })
        }
        
        else {
            self.showAlertView(withTitle: "Info", andMessage: "Enter message", needCancel: false, completion: { _ in })
        }
    }
}


// MARK: - ChatShowDisplayLogic
extension ChatShowViewController: ChatShowDisplayLogic {
    func displayMessages(fromViewModel viewModel: ChatShowModels.Message.ViewModel) {
        // NOTE: Display the result from the Presenter
        if let messages = self.router?.dataStore?.messages, messages.count > 0 {
            performUIUpdatesOnMain {
                self.tableView.reloadData()
            }
        }
    }
    
    func displaySendMessage(fromViewModel viewModel: ChatShowModels.Message.ViewModel) {
        // NOTE: Display the result from the Presenter
        guard viewModel.error == nil else {
            self.showAlertView(withTitle: "Error", andMessage: viewModel.error!.localizedDescription, needCancel: false, completion: { _ in })
            return
        }
        
        performTasksOnAsyncAfter(nanoseconds: 5) {
            self.refreshData()
        }
    }
}


// MARK: - UITableViewDataSource
extension ChatShowViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        var numberOfSections: NSInteger = 0
        
        if let messages = self.router?.dataStore?.messages, messages.count > 0 {
            self.tableView.backgroundView = nil
            numberOfSections = 1
        }
            
        else {
            let emptyLabel = UILabel(frame: CGRect.init(origin: .zero, size: self.tableView.bounds.size))
            emptyLabel.text = "Messages List is Empty".localized()
            emptyLabel.textAlignment = .center
            self.tableView.backgroundView = emptyLabel
        }
        
        return numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.router?.dataStore?.messages == nil) ? 0 : self.router!.dataStore!.messages!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "MessageCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! MessageTableViewCell
        let message = self.router!.dataStore!.messages[indexPath.row]
        
        cell.setup(withItem: message, andIndexPath: indexPath)
        
        return cell
    }
}


// MARK: - UITableViewDelegate
extension ChatShowViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 4.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView              =   UIView.init(frame: CGRect.init(origin: .zero, size: CGSize.init(width: tableView.bounds.width, height: 4.0)))
        let footerViewStyle         =   SKStyleKit.style(withName: "sideMenuStyle")!
        footerView.backgroundColor  =   footerViewStyle.backgroundColor
        
        return footerView
    }
}


// MARK: - UITextViewDelegate
extension ChatShowViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        loadTextViewPlaceholder((textView.text == "Enter message".localized()) ? nil : textView.text)
        
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        loadTextViewPlaceholder((textView.text == "Enter message".localized()) ? nil : textView.text)

        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return (textView.text!.count + text.count) < 100
    }
}
