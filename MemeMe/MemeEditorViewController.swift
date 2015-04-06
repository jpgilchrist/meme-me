//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by James Gilchrist on 3/29/15.
//  Copyright (c) 2015 James Gilchrist. All rights reserved.
//

import UIKit
import CoreData

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //leave meme as an optional so that we know if it's instanstiated from another controller or not
    var meme: Meme?
    
    var isViewAdjustedForKeyboard = false
    
    //need outlets to the bars so that we can hide them when we build the image context
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var toolbar: UIToolbar!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var topTextField: MemeTextField!
    @IBOutlet weak var bottomTextField: MemeTextField!
    
    @IBOutlet weak var pickImageFromCameraButton: UIBarButtonItem!
    @IBOutlet weak var shareAndSaveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //if meme is not nil then it was instantiated by a segue and we need to update the view
        if let meme = self.meme {
            self.imageView.image = UIImage(data: meme.originalImageData)
            self.topTextField.text = meme.topText
            self.bottomTextField.text = meme.bottomText
        } else {
            self.shareAndSaveButton.enabled = false
        }
        
        self.imageView.backgroundColor = UIColor.darkGrayColor()
        
        enablePickImageFromCamera()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
                
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromKeyboardNotifications()
    }
    
    //hide the status bar otherwise the status bar would overlay the action buttons
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    //MARK: Image Picker
    
    //users can use the camera to select/take images only if the source type is available
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
    
    //after selecting the image for the meme
    // 1. Update the image
    // 2. enable the activity icon
    // 3. dismiss the image picker controller
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
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
    
    //adjust views frame positioning if the user is currently in the bottom text field and the view is not already adjusted
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.isFirstResponder() && !isViewAdjustedForKeyboard {
            if let keyboardHeight = getKeyboardHeight(notification) {
                self.view.frame.origin.y -= keyboardHeight
                isViewAdjustedForKeyboard = true
            }
        }
    }
    
    //adjust the views frame iff the view is in an adjusted state (i.e., don't move the screen down if it isn't up already)
    func keyboardWillHide(notification: NSNotification) {
        if isViewAdjustedForKeyboard {
            if let keyboardHeight = getKeyboardHeight(notification) {
                self.view.frame.origin.y += keyboardHeight
                isViewAdjustedForKeyboard = false
            }
   
        }
    }
    
    //derive the keyboard height from the notification object's userInfo
    func getKeyboardHeight(notification: NSNotification) -> CGFloat? {
        return (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue().height
    }
    
    
    // MARK: - Generating Memed Image
    
    func generateMemedImage() -> UIImage {
        hidebars(true)
        
        /*
            Graphics context is the entire view
        
            Note: I tried playing with using different views as the context, but by using the full
                screen we are utilizing the optimal aspect ratio for the image to be displayed anywhere
                on the device in the app.
        */
        UIGraphicsBeginImageContext(self.view.frame.size)

        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        hidebars(false)
        
        return memedImage
    }
    
    func hidebars(hidden: Bool) {
        self.navigationBar.hidden = hidden
        self.toolbar.hidden = hidden
    }
    
    @IBAction func shareAndSaveMeme() {

        //generate the meme image including the top and bottom text (without the navigation bar or toolbar)
        let memedImage = generateMemedImage()
        
        //if the meme data object is nil then we need to instantiate a new meme
        if self.meme == nil {
            let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            let context = appDelegate.managedObjectContext!
            
            //instantiate a new Meme using CoreData
            self.meme = NSEntityDescription.insertNewObjectForEntityForName("Meme", inManagedObjectContext: context) as? Meme
        }
        
        //setup meme properties
        self.meme?.topText = self.topTextField.text
        self.meme?.bottomText = self.bottomTextField.text
        self.meme?.originalImageData = UIImageJPEGRepresentation(self.imageView.image!, 1)
        self.meme?.memedImageData = UIImageJPEGRepresentation(memedImage, 1)
        
        //setup activity controller with the memedImage
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityController.completionWithItemsHandler = didFinishActivityView
        
        self.presentViewController(activityController, animated: true, completion: nil)
    }
    
    func didFinishActivityView (activity: String!, didFinish: Bool, items: [AnyObject]!, error: NSError!) -> Void {
        //if the activity view was closed (not cancelled) then persist the meme to CoreData
        if didFinish {
            let appDelegate =
            UIApplication.sharedApplication().delegate as AppDelegate
            let managedContext = appDelegate.managedObjectContext!
            
            //if there was no error in persisting the Meme to CoreData then close the MemeEditor
            var error: NSError?
            if !managedContext.save(&error) {
                println("Could not save \(error), \(error?.userInfo)")
            } else {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
}
