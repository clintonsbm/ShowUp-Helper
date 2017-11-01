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
        dateFormatter.timeZone = TimeZone.current
        
        return Int(dateFormatter.string(from: self as Date))!
    }
    
    var minute: Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm"
        dateFormatter.timeZone = TimeZone.current
        
        return Int(dateFormatter.string(from: self as Date))!
    }
    
    var second: Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ss"
        dateFormatter.timeZone = TimeZone.current
        
        return Int(dateFormatter.string(from: self as Date))!
    }
    
    var day: Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        dateFormatter.timeZone = TimeZone.current
        
        return Int(dateFormatter.string(from: self as Date))!
    }
    
    var dayInWeek: Int {
        ///Day of week from 0 to 6 (sunday to saturday)
        return Calendar.current.component(.weekday, from: self as Date) - 1
    }
    
    var dayOfWeek: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.calendar = Calendar.current
        
        //For some reason we have to subtract one day from the weekday
        return dateFormatter.weekdaySymbols[Calendar.current.component(.weekday, from: self as Date) - 1]
    }
    
    var weekOfMonth: Int {
        
        return Calendar.current.component(.weekOfMonth, from: self as Date)
    }
    
    var weekOfYear: Int {
        
        return Calendar.current.component(.weekOfYear, from: self as Date)
    }
    
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        dateFormatter.timeZone = TimeZone.current
        
        return dateFormatter.string(from: self as Date)
    }
    
    var monthInt: Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        dateFormatter.timeZone = TimeZone.current
        
        return Int(dateFormatter.string(from: (self as Date) as Date))!
    }
    
    var year: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        dateFormatter.timeZone = TimeZone.current
        
        return dateFormatter.string(from: self as Date)
    }
    
    var startOfWeek: Int {
        let inputDate = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self as Date))! as NSDate
        
        return inputDate.day
    }
    
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        
        return dateFormatter.string(from: self as Date)
    }
    
    
    ///Necessery?
    func formatedTwoCases() -> (String, String, String) {
        return(String(format: "%02d", self.hour), String(format: "%02d", self.minute), String(format: "%02d", self.second))
    }
}
















