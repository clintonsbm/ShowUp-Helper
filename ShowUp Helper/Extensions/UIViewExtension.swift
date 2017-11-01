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
    
    func appearFromBottom(in view: UIView, withTime time: Double = 0.5) {
        let maskView = UIView(frame: UIScreen.main.bounds)
        
        maskView.tag = 190
        
        maskView.backgroundColor = UIColor.black
        maskView.alpha = 0.0
        
        view.addSubview(maskView)
        
        let moveToY = view.frame.height - self.frame.height
        
        view.bringSubview(toFront: self)
        
        UIView.animate(withDuration: time, animations: {
            self.frame.origin.y = moveToY
            maskView.alpha = 0.4
        })
    }
    
    func disappearOnBottom(in view: UIView, withTime time: Double = 0.5) {
        if let maskView = view.viewWithTag(190) {
            UIView.animate(withDuration: time, animations: {
                self.frame.origin.y = view.frame.height
                maskView.alpha = 0
            }, completion: { (_) in
                maskView.removeFromSuperview()
                self.removeFromSuperview()
            })
        }
        
        
    }
}
