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
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MemeCollection.sharedCollection.memeCollection.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellID = "memeCell"
        let ellipsis = "..."
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel!.text = MemeCollection.sharedCollection.memeCollection[indexPath.row].topText + ellipsis +
                               MemeCollection.sharedCollection.memeCollection[indexPath.row].bottomText
        cell.imageView?.image = MemeCollection.sharedCollection.memeCollection[indexPath.row].memeImage

        return cell
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let segueIdentifier = "tableViewDetail"
        performSegueWithIdentifier(segueIdentifier, sender: self)
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            MemeCollection.sharedCollection.removeMemeAtIndexFromCollection(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    // Return to MemeEditorViewController
    @IBAction func createNewMeme(sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let memeEditorViewController = storyboard.instantiateViewControllerWithIdentifier("memeEditor") as! MemeEditorViewController
        self.presentViewController(memeEditorViewController, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let indexPath = tableView.indexPathForSelectedRow() {
            let detailController = segue.destinationViewController as! MemeDetailViewController
            detailController.memeImageView.image = MemeCollection.sharedCollection.memeCollection[indexPath.row].memeImage
        }
    }
    
}
