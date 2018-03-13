//
//  TextField.swift
//  LoginSignup
//
//  Created by Vetaliy Poltavets on 3/13/18.
//  Copyright © 2018 vpoltave. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    func customTextField() -> Void {
//        self.layer.cornerRadius = 20.0
        self.layer.borderWidth = 1.7
        self.layer.borderColor = UIColor.dimBlue.cgColor
        let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 25.0, height: 2.0))
        self.leftView = leftView
        self.leftViewMode = .always
    }
    
    func removeSpaces() {
        self.text = self.text?.replacingOccurrences(of: " ", with: "")
    }
    
}
