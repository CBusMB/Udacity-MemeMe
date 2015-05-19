//
//  MemeCollectionTableViewController.swift
//  MemeMe
//
//  Created by Matthew Brown on 4/29/15.
//  Copyright (c) 2015 Crest Technologies. All rights reserved.
//

import UIKit

class MemeCollectionTableViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate
{
  let memes = MemeCollection.sharedCollection
  let reuseIdentifier = "memeCell"
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    
    navigationItem.leftBarButtonItem = editButtonItem()
    tableView.registerNib(UINib(nibName: "MemeCollectionTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
  }
  
  // MARK: - Table view data source
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return memes.memeCollection.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let ellipsis = "..."
    let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MemeCollectionTableViewCell
    let topText = memes.memeCollection[indexPath.row].topText
    let bottomText = memes.memeCollection[indexPath.row].bottomText
    cell.mainTextLabel!.text =  topText + ellipsis + bottomText
    cell.memeImageView.contentMode = .ScaleToFill
    cell.memeImageView?.image = memes.memeCollection[indexPath.row].image
    let attributedTopText = NSAttributedString(string: topText, attributes: MemeTextAttributes().inCellAttributes)
    let attributedBottomText = NSAttributedString(string: bottomText, attributes: MemeTextAttributes().inCellAttributes)
    cell.topTextLabel.attributedText = attributedTopText
    cell.bottomTextLabel.attributedText = attributedBottomText
    
    return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let detailViewController = storyboard.instantiateViewControllerWithIdentifier("memeDetailViewController") as! MemeDetailViewController
    // pass the indexPath.row of the selected meme to the detailViewController so that it can access the 
    // correct meme in MemeCollection.sharedCollection
    detailViewController.indexForMeme = indexPath.row
    detailViewController.hidesBottomBarWhenPushed = true
    navigationController?.pushViewController(detailViewController, animated: true)
  }
  
  override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
  }
  
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
      memes.removeMemeFromCollection(atIndex: indexPath.row)
      tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }
  }
  
  // Return to MemeEditorViewController
  @IBAction func segueToMemeEditor(sender: UIBarButtonItem) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let memeEditorViewController = storyboard.instantiateViewControllerWithIdentifier("memeEditorViewController") as! MemeEditorViewController
    self.presentViewController(memeEditorViewController, animated: true, completion: nil)
  }
  
}
