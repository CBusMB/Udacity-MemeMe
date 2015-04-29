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
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var topTextField: UITextField!
    
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var photoSelectorToolbar: UIToolbar!
    
    @IBOutlet weak var sharingNavigationBar: UINavigationBar!
    
    private let TopTextDefault = "TOP"
	
	private let BottomTextDefault = "BOTTOM"
    
    //var memeCollection = MemeCollection()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageToMeme.backgroundColor = UIColor.grayColor()
        self.sharingNavigationBar.backgroundColor = UIColor.grayColor()
		
		let memeTextAttributes = [
			NSStrokeColorAttributeName: UIColor.blackColor(),
			NSForegroundColorAttributeName: UIColor.whiteColor(),
			NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
			NSStrokeWidthAttributeName : -1.0
        ]
		
		topTextField.delegate = self
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.borderStyle = UITextBorderStyle.None
		topTextField.textAlignment = .Center
        topTextField.backgroundColor = UIColor.clearColor()
		topTextField.text = TopTextDefault
		bottomTextField.delegate = self
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.borderStyle = UITextBorderStyle.None
        bottomTextField.backgroundColor = UIColor.clearColor()
		bottomTextField.textAlignment = .Center
        bottomTextField.text = BottomTextDefault
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
        shareButton.enabled = false
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
        shareButton.enabled = true
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func saveMeme(editedMemeImage: UIImage) {
        if let originalImage = self.imageToMeme.image {
            let userGeneratedMeme = Meme(image: originalImage, memeImage: editedMemeImage, topText: topTextField.text, bottomText: bottomTextField.text)
            MemeCollection.collection.addMemeToCollection(userGeneratedMeme)
        }
    }
    
    @IBAction func shareMeme(sender: UIBarButtonItem) {
		let userEditedMemeImage = generateMemeImage()
        let activityItem = [userEditedMemeImage]
        let activityController = UIActivityViewController(activityItems: activityItem, applicationActivities: nil)
        self.presentViewController(activityController, animated: true, completion: nil)
        activityController.completionWithItemsHandler = {(String, Bool, [AnyObject]!, NSError) in
            self.saveMeme(userEditedMemeImage)
            self.dismissViewControllerAnimated(true, completion: nil)
		}
    }
    
    func generateMemeImage() -> UIImage {
        // hide the navigationBar and toolBar so that they aren't part of the meme
        self.sharingNavigationBar.hidden = true
        self.photoSelectorToolbar.hidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let meme = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.sharingNavigationBar.hidden = false
        self.photoSelectorToolbar.hidden = false
        return meme
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        sharingNavigationBar.hidden = true
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text == TopTextDefault || textField.text == BottomTextDefault {
			textField.text = String()
		}
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        sharingNavigationBar.hidden = false
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

