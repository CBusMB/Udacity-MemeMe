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
    let memes = MemeCollection.sharedCollection
    private let ReuseIdentifier = "memeCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.dataSource = self
        collectionView?.delegate = self
        navigationItem.leftBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        collectionView?.reloadData()
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        
        if editing {
            editingCollectionView = true
        } else {
            editingCollectionView = false
        }
    }
    
    private var editingCollectionView: Bool = false {
        didSet {
            // hide or show the in-cell delete button when the Edit/Done button is tapped
            toggleDeleteButtonHidden(editingCollectionView)
        }
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
        
        // Add the UIButton to the collection view
        cell.deleteButton.layer.setValue(indexPath.item, forKey: "index")
        cell.deleteButton.addTarget(self, action: "removeMemesFromCollectionView:", forControlEvents: .TouchUpInside)
        if editingCollectionView {
            cell.deleteButton.hidden = false
        } else {
            cell.deleteButton.hidden = true
        }
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailViewController = storyboard.instantiateViewControllerWithIdentifier("memeDetailViewController") as! MemeDetailViewController
        detailViewController.memeImage = memes.memeCollection[indexPath.item].memeImage
        detailViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func toggleDeleteButtonHidden(buttonVisibilityToggle: Bool) {
        for cell in collectionView!.visibleCells() as! [MemeCollectionCollectionViewCell] {
            var indexPathForCell = collectionView!.indexPathForCell(cell)
            var cellAtIndexPath = collectionView!.cellForItemAtIndexPath(indexPathForCell!) as! MemeCollectionCollectionViewCell
            cellAtIndexPath.deleteButton.hidden = !buttonVisibilityToggle
        }
    }
    
    func removeMemesFromCollectionView(sender: UIButton) {
        let memeIndex = sender.layer.valueForKey("index") as! Int
        memes.removeMemeAtIndexFromCollection(memeIndex)
        collectionView?.reloadData()
    }
    
    // Go to MemeEditorViewController
    @IBAction func segueToMemeEditor(sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let memeEditorViewController = storyboard.instantiateViewControllerWithIdentifier("memeEditorViewController") as! MemeEditorViewController
        self.presentViewController(memeEditorViewController, animated: true, completion: nil)
    }
}
