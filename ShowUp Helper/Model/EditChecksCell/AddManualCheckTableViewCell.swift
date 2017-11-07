//
//  AddManualCheckTableViewCell.swift
//  ShowUp Helper
//
//  Created by Clinton de Sá Barreto Maciel on 07/11/2017.
//  Copyright © 2017 Clinton Barreto. All rights reserved.
//

import UIKit

class AddManualCheckTableViewCell: UITableViewCell {
    
    static let identifier = "AddManualCheckTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        print("select")
    }
    
}
