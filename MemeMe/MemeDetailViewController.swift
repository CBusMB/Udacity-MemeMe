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
    var memeImage: UIImage?
    
    @IBOutlet weak var memeImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit Meme", style: .Plain, target: self, action: "segueToMemeEditor")
        
        // Tap recognizer
        let imageTap = UITapGestureRecognizer(target: self, action: "imageTapped:")
        imageTap.numberOfTapsRequired = 1
        imageTap.numberOfTouchesRequired = 1
        memeImageView.addGestureRecognizer(imageTap)
        memeImageView.userInteractionEnabled = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        memeImageView.image = memeImage
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
    
//    func segueToMemeEditor() {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let memeEditor = storyboard.instantiateViewControllerWithIdentifier("memeEditorViewController") as! MemeEditorViewController
//        
//        self.presentViewController(memeEditor, animated: true, completion: nil)
//    }

}
