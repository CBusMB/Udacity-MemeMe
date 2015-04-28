//
//  ViewController.swift
//  MemeMe
//
//  Created by Matthew Brown on 4/27/15.
//  Copyright (c) 2015 Crest Technologies. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate
{
    @IBOutlet weak var imageToMeme: UIImageView!

    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var topTextField: UITextField!
    
    @IBOutlet weak var bottomTextField: UITextField!
    
    var userGeneratedMeme: Meme!
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : 3.0
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.grayColor()
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    @IBAction func imagePicker(sender: UIBarButtonItem) {
        // use a tag to distinguish between the 2 photo options
        let photoLibraryTag = 1
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        if sender.tag == photoLibraryTag {
            imagePicker.sourceType = .PhotoLibrary
        } else {
            imagePicker.sourceType = .Camera
        }
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imageToMeme.image = image
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func saveMeme() {
        let memeImage = generateMeme()
        if let originalImage = self.imageToMeme.image {
            let userGeneratedMeme = Meme(image: originalImage, memeImage: memeImage, topText: topTextField.text, bottomText: bottomTextField.text)
        }
        
    }
    
//    @IBAction func share(sender: UIBarButtonItem) {
//        saveMeme()
//        let activityItem = [userGeneratedMeme]
//        let applicationActivities = [UIActivityTypeAirDrop, UIActivityTypeSaveToCameraRoll, UIActivityTypePostToTwitter, UIActivityTypePostToFacebook]
//        let activityController = UIActivityViewController(activityItems: [activityItem], applicationActivities: applicationActivities)
//        self.presentViewController(activityController, animated: true, completion: nil)
//    }
    
    func generateMeme() -> UIImage {
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let meme = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return meme
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func keyboardWillShow(notification: NSNotification) {
        self.view.frame.origin.y -= keyboardHeight(notification)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y += keyboardHeight(notification)
    }
    
    func keyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
}

