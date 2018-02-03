//
//  UIViewController+Extensions.swift
//  CleanCase
//
//  Created by msm72 on 03.02.2018.
//  Copyright © 2018 msm72. All rights reserved.
//

import UIKit

extension UIViewController {
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
}
