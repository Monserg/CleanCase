//
//  String+Extensions.swift
//  CleanCase
//
//  Created by msm72 on 05.02.2018.
//  Copyright © 2018 msm72. All rights reserved.
//

import UIKit

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
}
