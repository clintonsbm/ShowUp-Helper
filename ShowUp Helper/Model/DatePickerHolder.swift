//
//  DatePickerHolder.swift
//  ShowUp Helper
//
//  Created by Clinton de Sá Barreto Maciel on 30/10/2017.
//  Copyright © 2017 Clinton Barreto. All rights reserved.
//

import UIKit

class DatePickerHolder: UIView {
    
    var dateSelectDelegate: DateSelectDelegate!
    
    @IBOutlet var pickerTitle: UILabel!
    @IBOutlet var containerView: UIView!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    
    var type: DateReturnType = DateReturnType.selectCustomDate
    
    static func createPicker() -> DatePickerHolder {
        let dateDatePicker = UINib(nibName: "DatePickerXib", bundle: nil)
        let datePickerKeyboard = dateDatePicker.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return datePickerKeyboard as! DatePickerHolder
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        self.dateSelectDelegate.cancelDateSelection()
        self.removeFromSuperview()
    }
    
    @IBAction func done(_ sender: UIButton) {
        self.removeFromSuperview()
        self.dateSelectDelegate.dateSelect(date: self.datePicker.date, to: self.type)
    }
}
