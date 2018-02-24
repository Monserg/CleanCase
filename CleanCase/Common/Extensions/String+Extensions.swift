//
//  String+Extensions.swift
//  CleanCase
//
//  Created by msm72 on 05.02.2018.
//  Copyright © 2018 msm72. All rights reserved.
//

import UIKit
import SwiftyXMLParser

extension String {
    // MARK: - Properties
    var first: String {
        return String(prefix(1))
    }
    
    var last: String {
        return String(suffix(1))
    }
    
    func lowercaseFirst() -> String {
        return first.lowercased() + String(dropFirst())
    }

    var uppercaseFirst: String {
        return first.uppercased() + String(dropFirst())
    }
    
    mutating func localize() {
        self = self.localized()
    }
    
    func addZero() -> String {
        return self.count == 1 ? "0" + self : self
    }
    
    func convertToFloat() -> Float {
        let time = self.components(separatedBy: " ").last!.replacingOccurrences(of: ":", with: ".")
        return Float(time)!
    }
    
    func getTime() -> String {
        return self.components(separatedBy: " ").last!
    }
    
    static func getNextDate(withDiff diff: Int) -> String {
        let nextDate                    =   Date().addingTimeInterval(TimeInterval(diff * 24 * 60 * 60))
        let dateFormatter               =   DateFormatter()
        dateFormatter.locale            =   NSLocale.current
        dateFormatter.dateFormat        =   "dd/MM/yyyy"
        
        return dateFormatter.string(from: nextDate)
    }
    
    static func createDateString(fromComponents components: DateComponents, withDateFormat dateFormat: String) -> String {
        let dateFormatter               =   DateFormatter()
        dateFormatter.locale            =   NSLocale.current
        dateFormatter.dateFormat        =   dateFormat

        return dateFormatter.string(from: Calendar.current.date(from: components)!)
    }
    
    func convertToValues() -> (orderID: Int16, clientID: Int16, price: Float, status: Int16, laundryID: Int16, collection: String?, delivery: String?, remarks: String?, instructions: String?) {
        // parse xml document
        let xml = try! XML.parse(self)
        
        let orderID: Int16              =   Int16(xml["order"].attributes["id"] ?? "0")!
        let clientID: Int16             =   Int16(xml["order"].attributes["clientid"] ?? "0")!
        let price: Float                =   Float(xml["order"].attributes["price"] ?? "0")!
        let status: Int16               =   Int16(xml["order"].attributes["status"] ?? "0")!
        let laundryID: Int16            =   Int16(xml["order"].attributes["laundryid"] ?? "0")!

        let collectionText              =   xml["order"]["collection"].text
        let deliveryText                =   xml["order"]["delivery"].text
        let remarksText                 =   xml["order"]["remarks"].text
        let instructionsText            =   xml["order"]["instructions"].text

        return (orderID: orderID, clientID: clientID, price: price, status: status, laundryID: laundryID, collection: collectionText, delivery: deliveryText, remarks: remarksText, instructions: instructionsText)
    }
}
