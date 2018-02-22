//
//  AboutShowViewController.swift
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
import WebKit
import SwiftSpinner

// MARK: - Input & Output protocols
class AboutShowViewController: UIViewController {
    // MARK: - Properties
    var webView: WKWebView!

    
    // MARK: - IBOutlets
    @IBOutlet weak var emptySceneLabel: UILabel! {
        didSet {
            emptySceneLabel.isHidden = true
            emptySceneLabel.text!.localize()
            emptySceneLabel.numberOfLines = 0
        }
    }
    
    
    // MARK: - Class Initialization
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addBackBarButtonItem()
        self.addBasketBarButtonItem(true)
        self.displayLaundryInfo(withName: Laundry.name, andPhoneNumber: "\(Laundry.phoneNumber ?? "")")
        
        // Network
        checkNetworkConnection({ [unowned self] success in
            if success {
                SwiftSpinner.show("Loading App data...".localized(), animated: true)
                
                // Add WKWebView
                let webConfiguration = WKWebViewConfiguration()
                self.webView = WKWebView(frame: .zero, configuration: webConfiguration)
                self.webView.uiDelegate = self
                self.webView.navigationDelegate = self
                self.view = self.webView
                
                let myURL = URL(string: "http://www.okyanuscleaners.co.il/%25d7%2590%25d7%2595%25d7%2593%25d7%2595%25d7%25aa/")
                let myRequest = URLRequest(url: myURL!)
                self.webView.load(myRequest)
            }
                
            else {
                self.emptySceneLabel.fadeTransition(0.9)
                self.emptySceneLabel.isHidden = false
            }
        })
    }    
}


// MARK: - WKUIDelegate
extension AboutShowViewController: WKUIDelegate {}


// MARK: - WKNavigationDelegate
extension AboutShowViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
        SwiftSpinner.hide()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Start to load")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Finish to load")
        SwiftSpinner.hide()
    }
}
