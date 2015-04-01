//
//  PreviewMemeViewController.swift
//  MemeMe
//
//  Created by James Gilchrist on 3/31/15.
//  Copyright (c) 2015 James Gilchrist. All rights reserved.
//

import UIKit

class PreviewMemeViewController: UIViewController {
    
    var meme: Meme!
    
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.grayColor()
        self.imageView.image = meme.memedImage
        
        self.imageView.backgroundColor = UIColor.grayColor()
        self.imageView.layer.borderWidth = CGFloat(3.0)
        self.imageView.layer.borderColor = UIColor.blackColor().CGColor
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
