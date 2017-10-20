//
//  IntExtension.swift
//  ShowUp Helper
//
//  Created by Clinton de Sá Barreto Maciel on 20/10/2017.
//  Copyright © 2017 Clinton Barreto. All rights reserved.
//

import Foundation

extension Int {
    func formatTwoCases() -> String {
        return String(format: "%02d", self)
    }
}
