//
//  MonthResumeFooter.swift
//  ShowUp Helper
//
//  Created by Clinton de Sá Barreto Maciel on 19/10/2017.
//  Copyright © 2017 Clinton Barreto. All rights reserved.
//

import UIKit
import CoreData

class MonthResumeFooter: UITableViewHeaderFooterView {

    @IBOutlet var totalTimeMorning: UILabel!
    @IBOutlet var totalTimeAfternoon: UILabel!
    @IBOutlet var totalTimeWeek: UILabel!
    
    static let identifier = "MonthResumeXib"
    
    override func draw(_ rect: CGRect) {
        // Drawing code
    }

    func set(weekChecks: [NSManagedObject]) {
        for check in weekChecks {
            //
        }
    }
}
