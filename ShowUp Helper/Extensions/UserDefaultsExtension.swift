//
//  UserDefaultsExtension.swift
//  ShowUp Helper
//
//  Created by Clinton de Sá Barreto Maciel on 04/10/2017.
//  Copyright © 2017 Clinton Barreto. All rights reserved.
//

import UIKit

extension UserDefaults {
    
    ///Inverts the status of checking. True is Checking In and false is Checking Out.
    func invertCheck(checkController: ChecksController) {
        
        if let check = UserDefaults.standard.object(forKey: "check") {
            if let checkAsBool = check as? Bool {
                UserDefaults.standard.set(!checkAsBool, forKey: "check")
                
                if checkAsBool {
                    checkController.checkIn()
                } else {
                    checkController.checkOut()
                }
            }
        } else {
            UserDefaults.standard.set(true, forKey: "check")
            checkController.checkIn()
        }
    }
    
    ///Returns the current state of check.
    func isWorking() -> Bool {
        if let check = UserDefaults.standard.object(forKey: "check") {
            if let checkAsBool = check as? Bool {
                
                return checkAsBool
            }
            
            return false
        } else {
            
            return false
        }
    }
    
    ///Returns a string containing the "state check"", if the user is starting or ending the work.
    func getCheckLabelAnColor() -> (String, UIColor) {
        let check = UserDefaults.standard.object(forKey: "check")
        
        if let checkAsBool = check as? Bool {
            
            switch checkAsBool {
            case true:
                return ("Start", UIColor(red: 68/255, green: 219/255, blue: 94/255, alpha: 1))
            case false:
                return ("Stop", UIColor(red: 254/255, green: 56/255, blue: 36/255, alpha: 1))
            }
        } else {
            
            return ("Stop", UIColor(red: 254/255, green: 56/255, blue: 36/255, alpha: 1))
        }
    }
    
    ///Saves the check in date
    func saveCheckIn(date: NSDate) {
        UserDefaults.standard.set(date, forKey: "checkIn")
    }
    
    ///Saves the check out date
    func saveCheckOut(date: NSDate) {
        UserDefaults.standard.set(date, forKey: "checkOut")
    }
    
    func saveQRImage(image: UIImage){
        let imageData = UIImagePNGRepresentation(image)
        
        UserDefaults.standard.set(imageData, forKey: "qrImage")
    }
    
    func retriveQRCode() -> UIImage{
        let emptyStateQRCode = "emptyStateQRCode"
        
        guard let imageData = UserDefaults.standard.object(forKey: "qrImage") as? Data else {
            return UIImage(named: emptyStateQRCode)!
        }
        
        guard let image = UIImage(data: imageData) else {
            return UIImage(named: emptyStateQRCode)!
        }
        
        return image
    }
}






















