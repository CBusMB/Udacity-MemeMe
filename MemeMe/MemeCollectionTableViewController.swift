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
    let memeDetailSegue = "tableViewDetail"
    let memeEditorSegue = "returnToMemeEditor"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
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
        let cellID = "memeCell"
        let ellipsis = "..."
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel!.text = memes.memeCollection[indexPath.row].topText + ellipsis +
                               memes.memeCollection[indexPath.row].bottomText
        cell.imageView?.image = memes.memeCollection[indexPath.row].memeImage

        return cell
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier(memeDetailSegue, sender: self)
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            memes.removeMemeAtIndexFromCollection(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    // MARK: - Navigation
    
    // Return to MemeEditorViewController
    @IBAction func createNewMeme(sender: UIBarButtonItem) {
        performSegueWithIdentifier(memeEditorSegue, sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == memeDetailSegue {
            if let indexPath = tableView.indexPathForSelectedRow() {
                let detailController = segue.destinationViewController as! MemeDetailViewController
                detailController.memeImage = memes.memeCollection[indexPath.row].memeImage
            }
        
        
            
        }
    }
}
