//
//  MemeTextField.swift
//  MemeMe
//
//  Created by James Gilchrist on 3/30/15.
//  Copyright (c) 2015 James Gilchrist. All rights reserved.
//

import UIKit

/*
 * Note: Definitely struggled with the attributed strings. Had certain cases where the defaultTextAttributes were not applied
 *          so I often simply just set the attributedString with attributes at all times.
*/

class MemeTextField: UITextField, UITextFieldDelegate {
    
    private var reuseAttributedPlaceholder: NSAttributedString = NSAttributedString()
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -3.0
    ]
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //setup textField
        self.defaultTextAttributes = memeTextAttributes
        self.textAlignment = .Center
        
        //set placeholder from storyboard as attributedPlaceholder
        if let p = self.placeholder {
            self.attributedPlaceholder = NSAttributedString(string: p, attributes: memeTextAttributes)
        }
        
        //use self as delegat since it's the same for both top & bottom text fields
        self.delegate = self
    }
    
    //force all charactes to be captialized. Setting autoCapitalization didn't work since someone could simply hit the Shift Key and it would allow them to type lowercase characters
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var newText = textField.text as NSString
        newText = newText.stringByReplacingCharactersInRange(range, withString: string)
        
        //to avoid weird cases of the text not being formatted correctly, I set the attribtuedText with the default text attributes
        textField.attributedText = NSAttributedString(string: newText.uppercaseString, attributes: memeTextAttributes)
        
        
        //never allow it to replace characters on it's own accord
        return false
    }
    
    //resign first responder on return key
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.resignFirstResponder()
        
        return false
    }
    
    //to force the text to go away when entering the text field (a requirement of the project)
    // 1. Store the placeholder text (as defined in the storyboard) in a private variable
    // 2. Set the current placeholder to ""
    func textFieldDidBeginEditing(textField: UITextField) {
        reuseAttributedPlaceholder = textField.attributedPlaceholder!
        textField.placeholder = ""
    }
    
    //to get the placeholder text (as defined in the storyboard) back
    // 1. set the attributedPlaceholder to the locally saved private variable
    // Note: you don't have to create a new NSAttributedString because the local, private version is already NSAttributedString
    func textFieldDidEndEditing(textField: UITextField) {
        textField.attributedPlaceholder = reuseAttributedPlaceholder
    }
    
    

}
