//
//  CheckInOutRange TableViewCell.swift
//  ShowUp Helper
//
//  Created by Clinton de Sá Barreto Maciel on 17/10/2017.
//  Copyright © 2017 Clinton Barreto. All rights reserved.
//

import UIKit

class CheckInOutRange_TableViewCell: UITableViewCell {

    @IBOutlet var week: UILabel!
    @IBOutlet var weekBackgroundView: UIView!
    
    @IBOutlet var fromDay: UILabel!
    @IBOutlet var toDay: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
