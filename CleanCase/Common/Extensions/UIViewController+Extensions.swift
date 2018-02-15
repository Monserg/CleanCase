//
//  UIViewController+Extensions.swift
//  CleanCase
//
//  Created by msm72 on 03.02.2018.
//  Copyright © 2018 msm72. All rights reserved.
//

import UIKit

extension UIViewController {
    func checkNetworkConnection(_ completion: @escaping ((_ success: Bool) -> Void)) {
        guard isNetworkAvailable else {
            self.showAlertView(withTitle: "Error", andMessage: "Disconnected from Network", needCancel: false, completion: { _ in
                completion(false)
            })
            
            return
        }
        
        completion(true)
    }

    
    
    func showAlertView(withTitle title: String, andMessage message: String, needCancel cancel: Bool, completion: @escaping ((Bool) -> ())) {
        let alertViewController = UIAlertController.init(title: title.localized(), message: message.localized(), preferredStyle: .alert)
        
        let alertViewControllerOkAction = UIAlertAction.init(title: "Ok".localized(), style: .default, handler: { action in
            return completion(true)
        })

        if cancel {
            let alertViewControllerCancelAction = UIAlertAction.init(title: "Cancel".localized(), style: .cancel, handler: { action in
                return completion(false)
            })

            alertViewController.addAction(alertViewControllerCancelAction)
        }
        
        alertViewController.addAction(alertViewControllerOkAction)
        present(alertViewController, animated: true, completion: nil)
    }
    
    public func createPopover(withName name: String) {
        let storyboard: UIStoryboard = UIStoryboard(name: name, bundle: nil)
        let presentedViewController = storyboard.instantiateViewController(withIdentifier: name + "VC")
        presentedViewController.providesPresentationContextTransitionStyle = true
        presentedViewController.definesPresentationContext = true
        presentedViewController.modalPresentationStyle = .overCurrentContext
        presentedViewController.view.backgroundColor = UIColor.init(white: 0.4, alpha: 0.8)

        self.present(presentedViewController, animated: true, completion: nil)
    }
    
    public func addNavigationBarShadow() {
        self.navigationController?.navigationBar.layer.masksToBounds = false
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.gray.cgColor
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.8
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 4.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 4
    }
    
    public func displayLaundryInfo(withName name: String, andPhoneNumber phone: String?) {
        let laundryBarButton = UIBarButtonItem()
        laundryBarButton.customView = LaundryView(withName: name, andPhoneNumber: phone)
        self.navigationItem.rightBarButtonItem = laundryBarButton
    }
    
    public func hideBackBarButton() {
        let backButton = UIBarButtonItem(title: "", style: .done, target: navigationController, action: nil)
        self.navigationItem.leftBarButtonItem = backButton
    }

    public func addBackBarButtonItem() {
        let backButton = UIButton.init(frame: CGRect.init(origin: .zero, size: CGSize.init(width: 10, height: 44)))
        backButton.setImage(UIImage.init(named: "icon-back-bar-button"), for: .normal)
        backButton.addTarget(self, action: #selector(handlerBackButtonTapped), for: .touchUpInside)
        backButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        backButton.setTitle("Back".localized(), for: .normal)
        backButton.setTitleColor(UIColor.white, for: .normal)
        backButton.setTitleColor(UIColor.gray, for: .highlighted)

        let backBarButtonItem = UIBarButtonItem.init(customView: backButton)
        self.navigationItem.leftBarButtonItems = [backBarButtonItem]
    }
    
    public func addBasketBarButtonItem(_ isEmpty: Bool) {
        let basketButton = UIButton.init(frame: CGRect.init(origin: .zero, size: CGSize.init(width: 20, height: 44)))
        basketButton.setImage(UIImage.init(named: (isEmpty) ? "icon-shopping-basket-empty" : "icon-shopping-basket-complete"), for: .normal)
        basketButton.addTarget(self, action: #selector(handlerBasketButtonTapped), for: .touchUpInside)
        basketButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let basketBarButtonItem = UIBarButtonItem.init(customView: basketButton)
        self.navigationItem.leftBarButtonItems?.append(basketBarButtonItem)
    }
    
    @objc func handlerBasketButtonTapped(_ sender: UIBarButtonItem) {
        print("BasketBarButtonItem tapped...")
    }

    @objc func handlerBackButtonTapped(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}


// MARK: - UIPopoverPresentationControllerDelegate
extension UIViewController: UIPopoverPresentationControllerDelegate {
    public func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
