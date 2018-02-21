//
//  UITextField+Extension.swift
//  CleanCase
//
//  Created by msm72 on 07.02.2018.
//  Copyright © 2018 msm72. All rights reserved.
//

import UIKit
import ActionKit
import SKStyleKit

enum PaddingSide {
    case Left(CGFloat)
    case Right(CGFloat)
    case Both(CGFloat)
}

extension UITextField {
    // MARK: - Class Initialization
    func showToolBar(withPickerViewDataSource dataSource: [PickerViewSupport], andSelectedItem selectedRow: Int, _ completion: @escaping HandlerPassDataCompletion) {
        let style               =   SKStyleKit.style(withName: "toolBarPickerViewStyle")!
        
        let pickerView = ToolBarPickerView(withFrame: .zero, andItems: dataSource)
        pickerView.selectRow(selectedRow, inComponent: 0, animated: true)
        
        let toolbar             =   UIToolbar()
        toolbar.barStyle        =   .default
        toolbar.barTintColor    =   style.barTintColor
        toolbar.isTranslucent   =   false
        toolbar.sizeToFit()
        
        // Create Done button
        let doneButton = UIBarButtonItem(title: "Done".localized(), style: .done) { sender in
            completion(pickerView.selectedRow(inComponent: 0))
        }
        
        doneButton.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17.0),
                                           NSAttributedStringKey.foregroundColor: UIColor.white], for: .normal)
        
        doneButton.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17.0),
                                           NSAttributedStringKey.foregroundColor: UIColor.white.lighter(amount: 0.8)], for: .highlighted)
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let cancelButton = UIBarButtonItem(title: "Cancel".localized(), style: .done) {
            completion(nil)
        }

        cancelButton.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17.0),
                                             NSAttributedStringKey.foregroundColor: UIColor.white], for: .normal)
        
        cancelButton.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17.0),
                                             NSAttributedStringKey.foregroundColor: UIColor.white.lighter(amount: 0.8)], for: .highlighted)

        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolbar.isUserInteractionEnabled    =   true
        
        self.inputAccessoryView             =   toolbar
        self.inputView                      =   pickerView
    }
    
    
    // MARK: - Class Functions
    func addPadding(_ padding: PaddingSide) {
        self.leftViewMode           =   .always
        self.layer.masksToBounds    =   true
        
        switch padding {
        case .Left(let spacing):
            let paddingView         =   UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            self.leftView           =   paddingView
            self.rightViewMode      =   .always
            
        case .Right(let spacing):
            let paddingView         =   UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            self.rightView          =   paddingView
            self.rightViewMode      =   .always
            
        case .Both(let spacing):
            let paddingView         =   UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            
            // Left
            self.leftView           =   paddingView
            self.leftViewMode       =   .always
            
            // Right
            self.rightView          =   paddingView
            self.rightViewMode      =   .always
        }
    }
}
