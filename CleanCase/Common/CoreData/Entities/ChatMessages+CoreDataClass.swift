//
//  ChatMessages+CoreDataClass.swift
//  CleanCase
//
//  Created by Denis Miltsine on 20/03/2018.
//  Copyright © 2018 msm72. All rights reserved.
//
//

import Foundation
import CoreData

@objc(ChatMessages)
public class ChatMessages: NSManagedObject {
    // MARK: - Class Initialization
    deinit {
        Logger.log(message: "Success", event: .Severe)
    }
    
    // MARK: - Class Functions
    func updateEntity(fromResponse responseAPI: ResponseAPIChatMessage) {
        self.created_date       =   getTodayString()
        self.laundry_id         =   responseAPI.LaundryId
        self.text               =   responseAPI.text
        
        self.save()
    }
 
    func updateEntity( laundry_id: Int32, text: String) {
        self.created_date       =   getTodayString()
        self.laundry_id         =   laundry_id
        self.text               =   text
        
        self.save()
    }
}

func getTodayString() -> String{
    
    let date = Date()
    let calender = Calendar.current
    let components = calender.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
    
    let year = components.year
    let month = components.month
    let day = components.day
    let hour = components.hour
    let minute = components.minute
    let second = components.second
    
    let today_string = String(year!) + "-" + String(month!) + "-" + String(day!) + " " + String(hour!)  + ":" + String(minute!) + ":" +  String(second!)
    
    return today_string
    
}

