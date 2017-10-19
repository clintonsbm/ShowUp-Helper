//
//  CheckInOutRange TableViewCell.swift
//  ShowUp Helper
//
//  Created by Clinton de Sá Barreto Maciel on 17/10/2017.
//  Copyright © 2017 Clinton Barreto. All rights reserved.
//

import UIKit

class CheckInOutRangeTableViewCell: UITableViewCell {

    @IBOutlet var week: UILabel!
    @IBOutlet var weekBackgroundView: UIView!
    
    @IBOutlet var fromDay: UILabel!
    @IBOutlet var toDay: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.weekBackgroundView.backgroundColor = UIColor.white
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
