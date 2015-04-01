//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by James Gilchrist on 3/29/15.
//  Copyright (c) 2015 James Gilchrist. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var meme: Meme!
    
    @IBOutlet weak var captureView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var topTextField: MemeTextField!
    @IBOutlet weak var bottomTextField: MemeTextField!
    
    @IBOutlet weak var pickImageFromCameraButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        enablePickImageFromCamera()
        
        if self.imageView.image == nil {
            self.shareAndSaveButton.enabled = false
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    //MARK: Image Picker
    
    func enablePickImageFromCamera() {
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
        self.imageView.image = image
        self.shareAndSaveButton.enabled = true
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func dismissMemeEditor(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Keyboard
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            if let keyboardHeight = getKeyboardHeight(notification) {
                self.view.frame.origin.y -= keyboardHeight
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            if let keyboardHeight = getKeyboardHeight(notification) {
                self.view.frame.origin.y += keyboardHeight
            }
   
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat? {
        return (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue().height
    }
    
    
    // MARK: - Generating Memed Image
    
    @IBOutlet weak var shareAndSaveButton: UIBarButtonItem!
    
    func generateMemedImage() -> UIImage {
        UIGraphicsBeginImageContext(self.captureView.frame.size)
        self.captureView.drawViewHierarchyInRect(self.imageView.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return memedImage
    }
    
    @IBAction func shareAndSaveMeme() {
        let memedImage = generateMemedImage()
        
        self.meme = Meme(topText: self.topTextField.text, bottomText: self.bottomTextField.text, originalImage: self.imageView.image!, memedImage: memedImage)
        
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityController.completionWithItemsHandler = didFinishActivityView
        
        self.presentViewController(activityController, animated: true, completion: nil)
    }
    
    func didFinishActivityView (activity: String!, didFinish: Bool, items: [AnyObject]!, error: NSError!) -> Void {
        if didFinish {
            if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate {
                delegate.memes.append(self.meme)
            }
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? PreviewMemeViewController {
            vc.meme = self.meme
        }
    }


}
