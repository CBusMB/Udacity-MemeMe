//
//  MemeCollectionCollectionViewController.swift
//  MemeMe
//
//  Created by Matthew Brown on 4/29/15.
//  Copyright (c) 2015 Crest Technologies. All rights reserved.
//

import UIKit


class MemeCollectionCollectionViewController: UICollectionViewController, UICollectionViewDataSource, UICollectionViewDelegate
{
    private let reuseIdentifier = "memeCell"
    let memes = MemeCollection.sharedCollection
    private let segueIdentifier = "collectionToDetail"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.memeCollection.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MemeCollectionCollectionViewCell
        
        let imageView = UIImageView(image: memes.memeCollection[indexPath.item].image)
        imageView.contentMode = .ScaleAspectFill
        // TODO: add meme text
        cell.backgroundView = imageView
        
        return cell
    }
    
    

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
    
    // MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == segueIdentifier {
            let cell = sender as! UICollectionViewCell
            if let indexPath = self.collectionView?.indexPathForCell(cell) {
                let detailViewController = segue.destinationViewController as! MemeDetailViewController
                detailViewController.memeImage = memes.memeCollection[indexPath.row].memeImage
            }
        }
        
    }
    
    // Return to MemeEditorViewController
    @IBAction func segueToMemeEditor(sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let memeEditorViewController = storyboard.instantiateViewControllerWithIdentifier("memeEditorViewController") as! MemeEditorViewController
        self.presentViewController(memeEditorViewController, animated: true, completion: nil)
    }

}
