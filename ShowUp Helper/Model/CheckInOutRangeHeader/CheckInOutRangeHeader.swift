//
//  CheckInOutRangeHeader.swift
//  ShowUp Helper
//
//  Created by Clinton de Sá Barreto Maciel on 19/10/2017.
//  Copyright © 2017 Clinton Barreto. All rights reserved.
//

import UIKit

class CheckInOutRangeHeader: UITableViewHeaderFooterView {

    @IBOutlet var week: UILabel!
    @IBOutlet var weekBackgroundView: UIView!
    
    @IBOutlet var fromDay: UILabel!
    @IBOutlet var toDay: UILabel!
    
    static let identifier = "CheckInOutRangeViewXib"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        self.weekBackgroundView.dropShadow()
    }
    
    func set(firstEntered: NSDate) {
        
        let weekNumber = String(format: "%02d", firstEntered.weekOfMonth)
        self.week.text = "Week \(weekNumber)"
        
        let from = firstEntered.startOfWeek
        let fromFormated = String(format: "%02d", from)
        self.fromDay.text = fromFormated
        
        let toFormated = String(format: "%02d", from + 6)
        self.toDay.text = toFormated
    }
}
