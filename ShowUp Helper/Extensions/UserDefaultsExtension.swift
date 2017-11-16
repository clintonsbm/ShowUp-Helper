//
//  UserDefaultsExtension.swift
//  ShowUp Helper
//
//  Created by Clinton de Sá Barreto Maciel on 04/10/2017.
//  Copyright © 2017 Clinton Barreto. All rights reserved.
//

import UIKit

enum MinimalTime: String {
    case morning = "morningMinimalTime"
    case afternoon = "afternoonMinimalTime"
    case week = "weekMinimalTime"
    case month = "monthMinimalTime"
}

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
    
    private var emptyStateQRCode: String {
        return "emptyStateQRCode"
    }
    
    private var profileImage: String {
        return "profileImage"
    }
    
    ///Inverts the status of checking. True is Checking In and false is Checking Out.
    func invertCheck(checkController: ChecksController) {
        
        if !self.isWorking() {
            UserDefaults.standard.set(true, forKey: self.isWorkingStr)
            let _ = checkController.checkIn()
        } else {
            UserDefaults.standard.set(false, forKey: self.isWorkingStr)
            let _ = checkController.checkOut(with: NSDate(), withCheckIn: nil)
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
        
        let start = "Start"
        let stop = "Stop"
        
        if let isWorking = check as? Bool {
            
            switch isWorking {
            case false:
                return (start, UIColor(red: 68/255, green: 219/255, blue: 94/255, alpha: 1))
            case true:
                return (stop, UIColor(red: 254/255, green: 56/255, blue: 36/255, alpha: 1))
            }
        } else {
            
            return (start, UIColor(red: 68/255, green: 219/255, blue: 94/255, alpha: 1))
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
    
    ///Saves the QRCode image
    func saveQRImage(image: UIImage) {
        let imageData = UIImagePNGRepresentation(image)
        
        UserDefaults.standard.set(imageData, forKey: self.qrImageStr)
    }
    
    ///Retrieves the QRCode image
    func retriveQRCode() -> UIImage {
        
        guard let imageData = UserDefaults.standard.object(forKey: self.qrImageStr) as? Data else {
            return UIImage(named: self.emptyStateQRCode)!
        }
        
        guard let image = UIImage(data: imageData) else {
            return UIImage(named: self.emptyStateQRCode)!
        }
        
        return image
    }
    
    ///Saves the profile image
    func saveProfileImage(image: UIImage) {
        let imageData = UIImagePNGRepresentation(image)
        
        UserDefaults.standard.set(imageData, forKey: self.profileImage)
    }
    
    ///Retrieves the profile image
    func retriveProfileImage() -> UIImage {
        
        guard let imageData = UserDefaults.standard.object(forKey: self.profileImage) as? Data else {
            return #imageLiteral(resourceName: "emptyStateProfile")
        }
        
        guard let image = UIImage(data: imageData) else {
            return UIImage(named: self.profileImage)!
        }
        
        return image
    }
    
    ///Save minimal parameter
    func saveMinimal(minimalCase: MinimalTime, secTime: Int) {
        UserDefaults.standard.set(secTime, forKey: minimalCase.rawValue)
    }
    
    ///Retrive minimal parameter
    func retrieveMinimal(minimalCase: MinimalTime) -> Int {
        if let secTime = UserDefaults.standard.object(forKey: minimalCase.rawValue) as? Int {
            return secTime
        } else {
            switch minimalCase {
            case .month:
                return 72000*20
            case .week:
                return 72000
            case .morning:
                return 43200
            case .afternoon:
                return 28800
            }
        }
    }
    
    ///Save user name
    //salva aqui pvt
}






















