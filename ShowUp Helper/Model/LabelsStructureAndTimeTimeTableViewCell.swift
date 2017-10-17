//
//  LabelsStructureAndTimeTimeTableViewCell.swift
//  ShowUp Helper
//
//  Created by Clinton de Sá Barreto Maciel on 17/10/2017.
//  Copyright © 2017 Clinton Barreto. All rights reserved.
//

import UIKit

class LabelsStructureAndTimeTimeTableViewCell: UITableViewCell {

    @IBOutlet var enteredLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var exitedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
