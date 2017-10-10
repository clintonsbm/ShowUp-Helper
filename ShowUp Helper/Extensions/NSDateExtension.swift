//
//  DateExtension.swift
//  ShowUp Helper
//
//  Created by Clinton de Sá Barreto Maciel on 06/10/2017.
//  Copyright © 2017 Clinton Barreto. All rights reserved.
//

import UIKit

extension NSDate {
    var hour: Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        
        return Int(dateFormatter.string(from: self as Date))!
    }
    
    var minute: Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm"
        
        return Int(dateFormatter.string(from: self as Date))!
    }
    
    var second: Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ss"
        
        return Int(dateFormatter.string(from: self as Date))!
    }
    
    var dayOfWeek: String {
        
        return DateFormatter().weekdaySymbols[Calendar.current.component(.weekday, from: self as Date)]
    }
    
    var weekOfMonth: Int {
        
        return Calendar.current.component(.weekOfMonth, from: self as Date)
    }
    
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        
        return dateFormatter.string(from: self as Date)
    }
    
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        
        return dateFormatter.string(from: self as Date)
    }
}
