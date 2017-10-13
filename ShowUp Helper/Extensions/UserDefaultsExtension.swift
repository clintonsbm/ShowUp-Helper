//
//  UserDefaultsExtension.swift
//  ShowUp Helper
//
//  Created by Clinton de Sá Barreto Maciel on 04/10/2017.
//  Copyright © 2017 Clinton Barreto. All rights reserved.
//

import UIKit

extension UserDefaults {
    
    private var isWorkingStr: String {
        return "check"
    }
    
    private var chckInStr: String {
        return "checkIn"
    }
    
    private var checkOutgStr: String {
        return "checkOut"
    }
    
    private var qrImageStr: String {
        return "qrImage"
    }
    
    ///Inverts the status of checking. True is Checking In and false is Checking Out.
    func invertCheck(checkController: ChecksController) {
        
        if !self.isWorking() {
            UserDefaults.standard.set(true, forKey: self.isWorkingStr)
            checkController.checkIn()
        } else {
            UserDefaults.standard.set(false, forKey: self.isWorkingStr)
            checkController.checkOut()
        }
    }
    
    ///Returns the current state of check.
    func isWorking() -> Bool {
        if let check = UserDefaults.standard.object(forKey: self.isWorkingStr) {
            if let isWorking = check as? Bool {
                
                return isWorking
            }
            
            return false
        } else {
            
            return false
        }
    }
    
    ///Returns a string containing the "state check"", if the user is starting or ending the work.
    func getCheckLabelAnColor() -> (String, UIColor) {
        let check = UserDefaults.standard.object(forKey: self.isWorkingStr)
        
        if let isWorking = check as? Bool {
            
            switch isWorking {
            case false:
                return ("Start", UIColor(red: 68/255, green: 219/255, blue: 94/255, alpha: 1))
            case true:
                return ("Stop", UIColor(red: 254/255, green: 56/255, blue: 36/255, alpha: 1))
            }
        } else {
            
            return ("Start", UIColor(red: 68/255, green: 219/255, blue: 94/255, alpha: 1))
        }
    }
    
    ///Saves the check in date
    func saveCheckIn(date: NSDate) {
        UserDefaults.standard.set(date, forKey: self.chckInStr)
    }
    
    ///Saves the check out date
    func saveCheckOut(date: NSDate) {
        UserDefaults.standard.set(date, forKey: self.checkOutgStr)
    }
    
    func saveQRImage(image: UIImage){
        let imageData = UIImagePNGRepresentation(image)
        
        UserDefaults.standard.set(imageData, forKey: self.qrImageStr)
    }
    
    func retriveQRCode() -> UIImage{
        let emptyStateQRCode = "emptyStateQRCode"
        
        guard let imageData = UserDefaults.standard.object(forKey: self.qrImageStr) as? Data else {
            return UIImage(named: emptyStateQRCode)!
        }
        
        guard let image = UIImage(data: imageData) else {
            return UIImage(named: emptyStateQRCode)!
        }
        
        return image
    }
}






















