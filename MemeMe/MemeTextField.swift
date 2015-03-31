//
//  MemeTextField.swift
//  MemeMe
//
//  Created by James Gilchrist on 3/30/15.
//  Copyright (c) 2015 James Gilchrist. All rights reserved.
//

import UIKit

class MemeTextField: UITextField, UITextFieldDelegate {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -3.0
        ]
        
        self.defaultTextAttributes = memeTextAttributes
        self.textAlignment = .Center
        self.autocapitalizationType = .AllCharacters
        if let p = self.placeholder {
            self.attributedPlaceholder = NSAttributedString(string: p, attributes: memeTextAttributes)
        }
        
        self.delegate = self
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.resignFirstResponder()
        
        return false
    }

}
