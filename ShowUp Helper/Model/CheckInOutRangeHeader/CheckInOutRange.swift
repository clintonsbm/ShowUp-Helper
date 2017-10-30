//
//  CheckInOutRange.swift
//  ShowUp Helper
//
//  Created by Clinton de Sá Barreto Maciel on 26/10/2017.
//  Copyright © 2017 Clinton Barreto. All rights reserved.
//

import UIKit

class CheckInOutRange: UIView {

    @IBOutlet var week: UILabel!
    @IBOutlet var weekBackgroundView: UIView!
    
    @IBOutlet var fromDay: UILabel!
    @IBOutlet var toDay: UILabel!
    
    static let identifier = "CheckInOutRangeViewXib"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.weekBackgroundView.backgroundColor = UIColor.white
        self.weekBackgroundView.dropShadow()
    }
    
    func set(firstEntered: NSDate) {
        
        self.week.text = "Week \(firstEntered.weekOfMonth.formatTwoCases())"
        
        self.fromDay.text = firstEntered.startOfWeek.formatTwoCases()
        
        var dateComponets = DateComponents()
        dateComponets.day = 6 - (firstEntered.day - firstEntered.startOfWeek)
        
        let to = Calendar.current.date(byAdding: dateComponets, to: firstEntered as Date) as NSDate?
        
        self.toDay.text = to?.day.formatTwoCases()
    }

}
