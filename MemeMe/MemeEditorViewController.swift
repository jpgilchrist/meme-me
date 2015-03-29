//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by James Gilchrist on 3/29/15.
//  Copyright (c) 2015 James Gilchrist. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var pickImageFromCameraButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        pickImageFromCameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }
    
    @IBAction func pickImageFromAlbum(sender: UIBarButtonItem) {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = .PhotoLibrary
        presentViewController(controller, animated: true, completion: nil)
    }
    

    @IBAction func pickImageFromCamera(sender: UIBarButtonItem) {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = .Camera
        presentViewController(controller, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        println("didFinishPickingImage \(image) \(editingInfo)")
        self.image.image = image
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
