//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by James Gilchrist on 4/5/15.
//  Copyright (c) 2015 James Gilchrist. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    var meme: Meme!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.backgroundColor = UIColor.lightGrayColor()
        self.imageView.contentMode = UIViewContentMode.ScaleAspectFit
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
     
        //load the memedImage on viewWillAppear so that it is updated correctly after the Meme is edited.
        self.imageView.image = UIImage(data: meme.memedImageData)
        
        //hide tab bar when in Meme Detail (would be weird and confusing if it was there)
        self.tabBarController?.tabBar.hidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //animate hiding the navigation bar so the user knows it's there
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        //puts the tab bar back before the view disappears (and more importanly before the other view appears)
        self.tabBarController?.tabBar.hidden = false
    }
    
    @IBAction func tapShowNaivtationBar(sender: UITapGestureRecognizer) {

        //show and hide navigationbar on tap
        if let isHidden = self.navigationController?.navigationBar.hidden {
            self.navigationController?.setNavigationBarHidden(!isHidden, animated: true)
        }
    }

    @IBAction func showMemeEditor(sender: UIBarButtonItem) {

        //modally present the Meme Editor
        self.performSegueWithIdentifier("ShowMemeEditorFromDetail", sender: meme)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        //set the meme for the Meme Editor
        if segue.identifier == "ShowMemeEditorFromDetail" {
            let dvc = segue.destinationViewController as MemeEditorViewController
            dvc.meme = sender as? Meme
        }
    }

}
