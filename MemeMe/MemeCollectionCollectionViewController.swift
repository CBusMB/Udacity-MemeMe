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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView?.dataSource = self
    collectionView?.delegate = self
    navigationItem.leftBarButtonItem = editButtonItem()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    collectionView?.reloadData()
  }
  
  override func setEditing(editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: true)
    // toggle editimg mode when Edit/Done button is tapped
    if editing {
      editingCollectionView = true
    } else {
      editingCollectionView = false
    }
  }
  
  private var editingCollectionView: Bool = false {
    didSet {
      // hide or show the in-cell delete button when the Edit/Done button is tapped
      toggleDeleteButtonHidden(editingStatus: editingCollectionView)
    }
  }
  
  // MARK: UICollectionViewDataSource
  
  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return memes.memeCollection.count
  }
  
  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let reuseIdentifier = "memeCell"
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MemeCollectionCollectionViewCell
    
    // create imageView with meme image and set it as cell's background image
    let imageView = UIImageView(image: memes.memeCollection[indexPath.item].image)
    imageView.contentMode = .ScaleToFill
    cell.backgroundView = imageView
    
    // set text attributes to NSAttributedString of meme text and assign to cell labels
    let topText = memes.memeCollection[indexPath.item].topText
    let bottomText = memes.memeCollection[indexPath.item].bottomText
    let attributedTopText = NSAttributedString(string: topText, attributes: MemeTextAttributes().inCellAttributes)
    let attributedBottomText = NSAttributedString(string: bottomText, attributes: MemeTextAttributes().inCellAttributes)
    cell.memeTopText.attributedText = attributedTopText
    cell.memeBottomText.attributedText = attributedBottomText
    
    // Add the UIButton to the collection view
    cell.deleteButton.layer.setValue(indexPath.item, forKey: "index")
    cell.deleteButton.addTarget(self, action: "removeMemeFromCollectionView:", forControlEvents: .TouchUpInside)
    
    // hide the in-cell delete button if not in editing mode
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
    // pass the indexPath.row of the selected meme to the detailViewController so that it can access the
    // correct meme in MemeCollection.sharedCollection
    detailViewController.indexForMeme = indexPath.item
    detailViewController.hidesBottomBarWhenPushed = true
    navigationController?.pushViewController(detailViewController, animated: true)
  }
  
  func toggleDeleteButtonHidden(#editingStatus: Bool) {
    for cell in collectionView!.visibleCells() as! [MemeCollectionCollectionViewCell] {
      let indexPathForCell = collectionView!.indexPathForCell(cell)
      let cellAtIndexPath = collectionView!.cellForItemAtIndexPath(indexPathForCell!) as! MemeCollectionCollectionViewCell
      // use the contrary value of editing status to determine to show or hide the delete buttons
      // if we are not editing, hide the buttons
      cellAtIndexPath.deleteButton.hidden = !editingStatus
    }
  }
  
  func removeMemeFromCollectionView(sender: UIButton) {
    let memeIndex = sender.layer.valueForKey("index") as! Int
    memes.removeMemeFromCollection(atIndex: memeIndex)
    collectionView?.reloadData()
  }
  
  // Go to MemeEditorViewController
  @IBAction func segueToMemeEditor(sender: UIBarButtonItem) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let memeEditorViewController = storyboard.instantiateViewControllerWithIdentifier("memeEditorViewController") as! MemeEditorViewController
    self.presentViewController(memeEditorViewController, animated: true, completion: nil)
  }
}
