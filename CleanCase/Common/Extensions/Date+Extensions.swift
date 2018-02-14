//
//  Date+Extensions.swift
//  CleanCase
//
//  Created by msm72 on 13.02.2018.
//  Copyright © 2018 msm72. All rights reserved.
//

import UIKit

extension Date {
    func globalTime() -> Date {
        let timeZone    =   TimeZone.current
        let seconds     =   TimeInterval(timeZone.secondsFromGMT(for: self))
        
        return Date(timeInterval: seconds, since: self)
    }
    
    static func getYear(fromDate date: Date) -> Int {
        let dateFormatter               =   DateFormatter()
        dateFormatter.locale            =   NSLocale.current
        dateFormatter.dateFormat        =   "yy"          // "dd.MM.yyyy"
        
        return Int(dateFormatter.string(from: date).addZero())!
    }
}
