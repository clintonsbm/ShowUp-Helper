//
//  SetGoals.swift
//  ShowUp Helper
//
//  Created by Clinton de Sá Barreto Maciel on 16/11/2017.
//  Copyright © 2017 Clinton Barreto. All rights reserved.
//

import UIKit

class SetGoals: UIView {

    @IBOutlet var weekTotalBtn: UIButton!
    @IBOutlet var morningBtn: UIButton!
    @IBOutlet var afternoonBtn: UIButton!
    
    var weekMinimal: Int {
        return UserDefaults().retrieveMinimal(minimalCase: .week)
    }
    
    var morningMinimal: Int {
        return UserDefaults().retrieveMinimal(minimalCase: .morning)
    }
    
    var afternoonMinimal: Int {
        return UserDefaults().retrieveMinimal(minimalCase: .afternoon)
    }
    
    static func createView() -> SetGoals {
        let editChecks = UINib(nibName: "SetGoalsXib", bundle: nil)
        let editChecksView = editChecks.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return editChecksView as! SetGoals
    }
    
    override func draw(_ rect: CGRect) {
        self.setupView()
    }
    
    @IBAction func closeAction(_ sender: UIButton) {
        if let superview = self.superview {
            self.disappearOnBottom(in: superview)
        }
    }
    
    func setupView() {
        self.weekTotalBtn.layer.cornerRadius = 3
        self.weekTotalBtn.layer.borderWidth = 1
        self.weekTotalBtn.layer.borderColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1).cgColor
        
        self.morningBtn.layer.cornerRadius = 3
        self.morningBtn.layer.borderWidth = 1
        self.morningBtn.layer.borderColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1).cgColor
        
        self.afternoonBtn.layer.cornerRadius = 3
        self.afternoonBtn.layer.borderWidth = 1
        self.afternoonBtn.layer.borderColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1).cgColor
    }

}
