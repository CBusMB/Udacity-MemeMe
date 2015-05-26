//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Matthew Brown on 4/29/15.
//  Copyright (c) 2015 Crest Technologies. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController
{
  let memes = MemeCollection.sharedCollection
  var indexForMeme: Int?
  
  @IBOutlet weak var memeImageView: UIImageView! {
    didSet {
      // Tap recognizer
      let imageTap = UITapGestureRecognizer(target: self, action: "imageTapped:")
      memeImageView.addGestureRecognizer(imageTap)
      memeImageView.userInteractionEnabled = true
      memeImageView.backgroundColor = UIColor.grayColor()
    }
  }
  
  @IBOutlet weak var memeTopTextLabel: UILabel!
  @IBOutlet weak var memeBottomTextLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: .Plain, target: self, action: "deleteMeme")
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    // get the index of the selected meme passed from the tableView or collectionView
    if let index = indexForMeme {
      // use that index to get our image and text from MemeCollection.sharedCollection
      memeImageView.image = memes.memeCollection[index].image
      let attributedTopText = NSAttributedString(string: memes.memeCollection[index].topText, attributes: MemeTextAttributes.attributes)
      let attributedBottomText = NSAttributedString(string: memes.memeCollection[index].bottomText, attributes: MemeTextAttributes.attributes)
      memeTopTextLabel.attributedText = attributedTopText
      memeBottomTextLabel.attributedText = attributedBottomText
    }
  }
  
  private func deleteMeme() {
    // create an alert controller and confirm deletion
    let deleteConfirmation = UIAlertController(title: "Delete This Meme?", message: "This action cannot be undone", preferredStyle: .ActionSheet)
    let delete = UIAlertAction(title: "Delete", style: .Destructive) { Void in
      // on confirmation to delete, update the shared memeCollection and pop back one on the navigation stack
      self.memes.removeMemeFromCollection(atIndex: self.indexForMeme!)
      self.navigationController?.popViewControllerAnimated(true) }
    
    deleteConfirmation.addAction(delete)
    let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
    deleteConfirmation.addAction(cancel)
    self.presentViewController(deleteConfirmation, animated: true, completion: nil)
  }
  
  private func imageTapped(recognizer: UITapGestureRecognizer) {
    if recognizer.state == UIGestureRecognizerState.Ended {
      // hide the navigationBar to better see the meme
      if !navigationController!.navigationBarHidden {
        navigationController?.setNavigationBarHidden(true, animated: true)
      } else {
        navigationController?.setNavigationBarHidden(false, animated: true)
      }
    }
  }
}
