//
//  MonthResumeFooter.swift
//  ShowUp Helper
//
//  Created by Clinton de Sá Barreto Maciel on 19/10/2017.
//  Copyright © 2017 Clinton Barreto. All rights reserved.
//

import UIKit
import CoreData

class MonthResumeCell: UITableViewCell {

    @IBOutlet var totalTimeMorning: UILabel!
    @IBOutlet var totalTimeAfternoon: UILabel!
    @IBOutlet var totalTimeWeek: UILabel!
    
    @IBOutlet var checkMorning: UILabel!
    @IBOutlet var checkAfternoon: UILabel!
    @IBOutlet var checkTimeWeek: UILabel!
    
    static let identifier = "MonthResumeXib"
    
    var totalMorning: Double = 0
    var totalAfternoon: Double = 0
    
    private static let emojiTrue = "✅"
    private static let emojiFalse = "⚠️"
    
    override func awakeFromNib() {
        self.selectionStyle = .none
    }

    func set(weekChecks: [NSManagedObject]) {
        for _ in weekChecks {
            //continuar daqui
            
        }
    }
}
