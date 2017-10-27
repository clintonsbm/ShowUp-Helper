//
//  BaseDateHandler.swift
//  ShowUp Helper
//
//  Created by Clinton de Sá Barreto Maciel on 27/10/2017.
//  Copyright © 2017 Clinton Barreto. All rights reserved.
//

import UIKit

class BaseDateHandler: NSObject {
    static func addWeekIn(date: NSDate) -> NSDate? {
//        let inputDate = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: self.baseDate as Date))!
        
        var dateComponets = DateComponents()
        dateComponets.day = 7
        
        let newDate = Calendar.current.date(byAdding: dateComponets, to: date as Date) as NSDate?
        
        return newDate
    }
    
    static func removeWeekIn(date: NSDate) -> NSDate? {
        //        let inputDate = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: self.baseDate as Date))!
        
        var dateComponets = DateComponents()
        dateComponets.day = -7
        
        let newDate = Calendar.current.date(byAdding: dateComponets, to: date as Date) as NSDate?
        
        return newDate
    }
}
