//
//  UITextField+Extension.swift
//  CleanCase
//
//  Created by msm72 on 07.02.2018.
//  Copyright © 2018 msm72. All rights reserved.
//

import UIKit
import ActionKit

extension UITextField {
    // MARK: - Class Initialization
    func showToolBar(withPickerViewDataSource dataSource: [PickerViewSupport], andSelectedItem selectedRow: Int, _ completion: @escaping HandlerPassDataCompletion) {
        let pickerView = ToolBarPickerView(withFrame: .zero, andItems: dataSource)
        pickerView.selectRow(selectedRow, inComponent: 0, animated: true)
        
        let toolbar             =   UIToolbar()
        toolbar.barStyle        =   .default
        toolbar.barTintColor    =   .black
        toolbar.isTranslucent   =   false
        toolbar.sizeToFit()
        
        // Create Done button
        let doneButton = UIBarButtonItem(title: "Done".localized(), style: .done) { sender in
            completion(pickerView.selectedRow(inComponent: 0))
        }
                    
//        doneButton.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.setupBy("Calibri", withStyle: .Bold, andSize: 20.0),
//                                           NSAttributedStringKey.foregroundColor: UIColor.white], for: .normal)
//
//        doneButton.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.setupBy("Calibri", withStyle: .Bold, andSize: 20.0),
//                                           NSAttributedStringKey.foregroundColor: UIColor.white.lighter(amount: 0.7)], for: .highlighted)

        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let cancelButton = UIBarButtonItem(title: "Cancel".localized(), style: .done) {
            completion(nil)
        }

//        cancelButton.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.setupBy("Calibri", withStyle: .Bold, andSize: 20.0),
//                                             NSAttributedStringKey.foregroundColor: UIColor.white], for: .normal)
//        
//        cancelButton.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.setupBy("Calibri", withStyle: .Bold, andSize: 20.0),
//                                             NSAttributedStringKey.foregroundColor: UIColor.white.lighter(amount: 0.7)], for: .highlighted)
        
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolbar.isUserInteractionEnabled    =   true
        
        self.inputAccessoryView             =   toolbar
        self.inputView                      =   pickerView
    }
}
