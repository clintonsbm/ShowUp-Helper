//
//  UIViewExtension.swift
//  ShowUp Helper
//
//  Created by Clinton de Sá Barreto Maciel on 09/10/2017.
//  Copyright © 2017 Clinton Barreto. All rights reserved.
//

import UIKit

extension UIView {
    func dropShadow(withOpacity opacity : Float = 0.4) {
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowRadius = 5
    }
    
    func fadeIn() {
        let maskView = UIView(frame: self.frame)
        
//        maskView.accessibilityIdentifier = "masViewIdentifier"
        maskView.tag = 190
        
        maskView.backgroundColor = UIColor.black
        maskView.alpha = 0.0
        
        UIView.animate(withDuration: 0.5) {
            maskView.alpha = 0.4
        }
        
        self.addSubview(maskView)
    }
    
    func fadeOut() {
        if let maskView = self.viewWithTag(190) {
            
            UIView.animate(withDuration: 0.5, animations: {
                maskView.alpha = 0
            }, completion: { (_) in
                maskView.removeFromSuperview()
            })
        }
    }
}
