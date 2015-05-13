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
      imageTap.numberOfTapsRequired = 1
      imageTap.numberOfTouchesRequired = 1
      memeImageView.addGestureRecognizer(imageTap)
      memeImageView.userInteractionEnabled = true
    }
  }
  
  @IBOutlet weak var memeTopTextLabel: UILabel!
  @IBOutlet weak var memeBottomTextLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    // get the index of the selected meme passed from the tableView or collectionView
    if let index = indexForMeme {
      // use that index to get our image and text from MemeCollection.sharedCollection
      memeImageView.image = memes.memeCollection[index].image
      let attributedTopText = NSAttributedString(string: memes.memeCollection[index].topText, attributes: MemeTextAttributes().attributes)
      let attributedBottomText = NSAttributedString(string: memes.memeCollection[index].bottomText, attributes: MemeTextAttributes().attributes)
      memeTopTextLabel.attributedText = attributedTopText
      memeBottomTextLabel.attributedText = attributedBottomText
    }
  }
  
  func imageTapped(recognizer: UITapGestureRecognizer) {
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
