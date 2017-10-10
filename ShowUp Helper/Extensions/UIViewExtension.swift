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
}
