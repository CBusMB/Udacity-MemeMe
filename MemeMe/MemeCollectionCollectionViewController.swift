//
//  MemeCollectionCollectionViewController.swift
//  MemeMe
//
//  Created by Matthew Brown on 4/29/15.
//  Copyright (c) 2015 Crest Technologies. All rights reserved.
//

import UIKit


class MemeCollectionCollectionViewController: UICollectionViewController, UICollectionViewDataSource
{
    private let ReuseIdentifier = "memeCell"
    let memes = MemeCollection.sharedCollection
    private let SegueIdentifier = "collectionToDetail"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.dataSource = self
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.memeCollection.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ReuseIdentifier, forIndexPath: indexPath) as! MemeCollectionCollectionViewCell
        
        // create imageView with meme image and set as cell's background image
        let imageView = UIImageView(image: memes.memeCollection[indexPath.item].image)
        imageView.contentMode = .ScaleAspectFill
        cell.backgroundView = imageView
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName: UIColor.blackColor(),
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 16)!,
            NSStrokeWidthAttributeName : -1.0
        ]
        
        // set text attributes to NSAttributedString of meme text and assign to cell labels
        let memeTopText = memes.memeCollection[indexPath.item].topText
        let memeBottomText = memes.memeCollection[indexPath.item].bottomText
        let attributedTopText = NSAttributedString(string: memeTopText, attributes: memeTextAttributes)
        let attributedBottomText = NSAttributedString(string: memeBottomText, attributes: memeTextAttributes)
        cell.memeTopText.attributedText = attributedTopText
        cell.memeBottomText.attributedText = attributedBottomText
        
        return cell
    }
    
    // MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueIdentifier {
            let cell = sender as! UICollectionViewCell
            if let indexPath = self.collectionView?.indexPathForCell(cell) {
                let detailViewController = segue.destinationViewController as! MemeDetailViewController
                detailViewController.memeImage = memes.memeCollection[indexPath.row].memeImage
                detailViewController.hidesBottomBarWhenPushed = true
            }
        }
    }
    
    // Go to MemeEditorViewController
    @IBAction func segueToMemeEditor(sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let memeEditorViewController = storyboard.instantiateViewControllerWithIdentifier("memeEditorViewController") as! MemeEditorViewController
        self.presentViewController(memeEditorViewController, animated: true, completion: nil)
    }
}
