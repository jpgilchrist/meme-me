//
//  Meme.swift
//  MemeMe
//
//  Created by James Gilchrist on 4/2/15.
//  Copyright (c) 2015 James Gilchrist. All rights reserved.
//

import Foundation
import CoreData

class Meme: NSManagedObject {

    @NSManaged var topText: String
    @NSManaged var bottomText: String
    @NSManaged var originalImageData: NSData
    @NSManaged var memedImageData: NSData

}
