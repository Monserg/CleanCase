//
//  Message+CoreDataClass.swift
//  CleanCase
//
//  Created by msm72 on 25.03.2018.
//  Copyright © 2018 msm72. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Message)
public class Message: NSManagedObject {
    // MARK: - Properties
    class var nextCodeID: Int16 {
        get {
            if let messages = CoreDataManager.instance.readEntities(withName: "Message",
                                                                         withPredicateParameters: nil,
                                                                         andSortDescriptor: nil),
                messages.count > 0 {
                return Int16(messages.count - 1)
            }
            
            return 0
        }
    }

    
    // MARK: - Class Initialization
    deinit {
        Logger.log(message: "Success", event: .Severe)
    }
    
    
    // MARK: - Custom Functions
    func updateEntity(withType type: Int16, andText text: String) {
        self.date       =   String.createDate(withFormat: "dd/MM/yyyy HH:mm")            
        self.codeID     =   Message.nextCodeID
        self.text       =   text
        self.type       =   type
        
        self.save()
    }
    
    func getTodayString() -> String{
        let date        =   Date()
        let calender    =   Calendar.current
        let components  =   calender.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        let result      =   String(components.year!) + "-" + String(components.month!) + "-" + String(components.day!) + " " + String(components.hour!)  + ":" + String(components.minute!) + ":" +  String(components.second!)
        
        return result
        
    }
}

