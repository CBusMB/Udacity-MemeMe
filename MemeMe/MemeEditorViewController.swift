//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Matthew Brown on 4/27/15.
//  Copyright (c) 2015 Crest Technologies. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate
{
  private let TopTextDefault = "TOP"
  private let BottomTextDefault = "BOTTOM"
  let memes = MemeCollection.sharedCollection
  
  @IBOutlet weak var imageToMemeView: UIImageView! {
    didSet {
      imageToMemeView.backgroundColor = UIColor.grayColor()
      imageToMemeView.contentMode = .ScaleAspectFit
    }
  }
  
  @IBOutlet weak var cameraButton: UIBarButtonItem!
  @IBOutlet weak var shareButton: UIBarButtonItem!
  
  @IBOutlet weak var topTextField: UITextField! {
    didSet {
      setTextFieldAttributes(topTextField)
      topTextField.text = TopTextDefault
    }
  }
  
  @IBOutlet weak var bottomTextField: UITextField! {
    didSet {
      setTextFieldAttributes(bottomTextField)
      bottomTextField.text = BottomTextDefault
    }
  }
  
  private func setTextFieldAttributes(textField: UITextField) {
    textField.delegate = self
    textField.defaultTextAttributes = MemeTextAttributes.attributes
    textField.borderStyle = UITextBorderStyle.None
    textField.backgroundColor = UIColor.clearColor()
    textField.textAlignment = .Center
  }
  
  @IBOutlet weak var photoSelectorToolbar: UIToolbar!
  @IBOutlet weak var sharingNavigationBar: UINavigationBar!
  
  var memeImage: UIImage? {
    didSet {
      // Tap recognizer
      let imageTap = UITapGestureRecognizer(target: self, action: "imageTapped:")
      imageToMemeView.addGestureRecognizer(imageTap)
      imageToMemeView.userInteractionEnabled = true
    }
  }
  
  // MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
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
    
    // set imageToMeme.image if we have already have an image
    imageToMemeView.image = memeImage
    
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
  
  private func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
    if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
      memeImage = image
    }
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  // MARK: Meme saving and sharing
  
  private func save() {
    // Make sure we have an image
    if let selectedImage = memeImage {
      let userGeneratedMeme = Meme(image: selectedImage,
        topText: topTextField.text, bottomText: bottomTextField.text)
      memes.addMemeToCollection(userGeneratedMeme)
    }
  }
  
  @IBAction func shareMeme(sender: UIBarButtonItem) {
    let segueIdentifier = "showSentMemes"
    let userEditedMemeImage = generateMemeImage()
    let activityItem = [userEditedMemeImage]
    let activityController = UIActivityViewController(activityItems: activityItem, applicationActivities: nil)
    self.presentViewController(activityController, animated: true, completion: nil)
    activityController.completionWithItemsHandler = {(_, completed, _, _) in
      if completed {
        // user completed sharing activity
        self.save()
        self.performSegueWithIdentifier(segueIdentifier, sender: self)
      } else {
        // user cancelled sharing activity
        self.dismissViewControllerAnimated(true, completion: nil)
      }
    }
  }
  
  private func generateMemeImage() -> UIImage {
    // hide the navigationBar and toolBar so that they aren't part of the meme
    sharingNavigationBar.hidden = true
    photoSelectorToolbar.hidden = true
    
    UIGraphicsBeginImageContext(self.view.frame.size)
    self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
    let meme = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    sharingNavigationBar.hidden = false
    photoSelectorToolbar.hidden = false
    return meme
  }
  
  // MARK: Tap gesture recognizer
  private func imageTapped(recognizer: UITapGestureRecognizer) {
    if recognizer.state == UIGestureRecognizerState.Ended {
      // treat tapping the image as pressing return if the user has edited either text field
      if topTextField.isFirstResponder() {
        textFieldShouldReturn(topTextField)
      } else if bottomTextField.isFirstResponder() {
        textFieldShouldReturn(bottomTextField)
        // hide the top and bottom toolbars to better see the meme
      } else if imageToMemeView.image != nil {
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
  private func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
    sharingNavigationBar.hidden = true
    photoSelectorToolbar.hidden = true
    return true
  }
  
  private func textFieldDidBeginEditing(textField: UITextField) {
    if textField.text == TopTextDefault || textField.text == BottomTextDefault {
      textField.text = String()
    }
  }
  
  private func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    sharingNavigationBar.hidden = false
    photoSelectorToolbar.hidden = false
    return true
  }
  
  private func keyboardWillShow(notification: NSNotification) {
    // move the view so that the text field isn't obscured by the keyboard
    if bottomTextField.isFirstResponder() {
      self.view.frame.origin.y -= keyboardHeight(notification)
    }
  }
  
  private func keyboardWillHide(notification: NSNotification) {
    if bottomTextField.isFirstResponder() {
      self.view.frame.origin.y += keyboardHeight(notification)
    }
  }
  
  private func keyboardHeight(notification: NSNotification) -> CGFloat {
    let userInfo = notification.userInfo
    let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
    return keyboardSize.CGRectValue().height
  }
  
  private func subscribeToKeyboardNotifications() {
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
  }
  
  private func unsubscribeFromKeyboardNotifications() {
    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
  }
}

