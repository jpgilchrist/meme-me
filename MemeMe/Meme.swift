//
//  Meme.swift
//  MemeMe
//
//  Created by James Gilchrist on 3/31/15.
//  Copyright (c) 2015 James Gilchrist. All rights reserved.
//

import Foundation
import UIKit

struct Meme: Printable {
    var topText: String
    var bottomText: String
    var originalImage: UIImage
    var memedImage: UIImage
    
    init(topText:String, bottomText:String, originalImage:UIImage, memedImage:UIImage ) {
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = originalImage
        self.memedImage = memedImage
    }
    
    var description: String {
        return "top text: \(self.topText) bottom: \(self.bottomText) original image: \(self.originalImage)"
    }
}
