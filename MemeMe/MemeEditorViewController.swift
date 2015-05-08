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
  
  var memeImage: UIImage?
  private let TopTextDefault = "TOP"
  private let BottomTextDefault = "BOTTOM"
  private let segueIdentifier = "showSentMemes"
  let memes = MemeCollection.sharedCollection
  
  // MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.imageToMeme.backgroundColor = UIColor.grayColor()
    
    // textField attributes
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
    
    // Tap recognizers
    let imageTap = UITapGestureRecognizer(target: self, action: "imageTapped:")
    imageTap.numberOfTapsRequired = 1
    imageTap.numberOfTouchesRequired = 1
    imageToMeme.addGestureRecognizer(imageTap)
    imageToMeme.userInteractionEnabled = true
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    // check if device has camera
    cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
    
    // setup keyboard notifications
    self.subscribeToKeyboardNotifications()
    
    if memeImage == nil {
      shareButton.enabled = false
    } else {
      shareButton.enabled = true
    }
    
    // set imageToMeme if we have already have an image
    imageToMeme.image = memeImage
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    unsubscribeFromKeyboardNotifications()
  }
  
  
  // MARK: Image Picker methods
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
      memeImage = image
    }
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  // MARK: Meme saving and sharing
  
  /// :param: editedMemeImage The modified image to be saved as a Meme
  func save(#editedMemeImage: UIImage) {
    // Make sure we have an image
    if let originalImage = self.memeImage {
      let userGeneratedMeme = Meme(image: originalImage, memeImage: editedMemeImage,
        topText: topTextField.text, bottomText: bottomTextField.text)
      memes.addMemeToCollection(meme: userGeneratedMeme)
    }
  }
  
  @IBAction func shareMeme(sender: UIBarButtonItem) {
    let userEditedMemeImage = generateMemeImage()
    let activityItem = [userEditedMemeImage]
    let activityController = UIActivityViewController(activityItems: activityItem, applicationActivities: nil)
    self.presentViewController(activityController, animated: true, completion: nil)
    activityController.completionWithItemsHandler = {(activityType, completed, returnedItems, error) in
      if completed {
        // user completed sharing activity
        self.save(editedMemeImage: userEditedMemeImage)
        self.performSegueWithIdentifier(self.segueIdentifier, sender: self)
      } else {
        // user cancelled sharing activity
        activityController.dismissViewControllerAnimated(true, completion: nil)
      }
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
  
  // MARK: Tap gesture recognizer
  func imageTapped(recognizer: UITapGestureRecognizer) {
    if recognizer.state == UIGestureRecognizerState.Ended {
      // treat tapping the image as pressing return if the user has edited either text field
      if topTextField.isFirstResponder() {
        textFieldShouldReturn(topTextField)
      } else if bottomTextField.isFirstResponder() {
        textFieldShouldReturn(bottomTextField)
        // hide the top and bottom toolbars to better see the meme
      } else if imageToMeme.image != nil {
        if photoSelectorToolbar.hidden && sharingNavigationBar.hidden {
          photoSelectorToolbar.hidden = false
          sharingNavigationBar.hidden = false
        } else {
          photoSelectorToolbar.hidden = true
          sharingNavigationBar.hidden = true
        }
      }
    }
  }
  
  // MARK: Text field delegate, keyboard subscriptions
  func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
    sharingNavigationBar.hidden = true
    photoSelectorToolbar.hidden = true
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
    photoSelectorToolbar.hidden = false
    return true
  }
  
  func keyboardWillShow(notification: NSNotification) {
    
    // TODO: fix this for landscape view
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

