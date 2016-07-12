//
//  SentTableViewController.swift
//  MemeMe
//
//  Created by Javier Gomez on 7/5/16.
//  Copyright © 2016 Javier Gomez. All rights reserved.
//

import UIKit

class SentTableViewController: UITableViewController {

    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }


    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return memes.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TableViewCell")!
        let meme = self.memes[indexPath.row]
        
        cell.textLabel?.text = "\(meme.textTop) ... \(meme.textBottom)"
        cell.imageView?.image = meme.imageMemed

        return cell
    }
    

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detailedMemeController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailedMemeController.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailedMemeController, animated: true)
        
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete
        {
            (UIApplication.sharedApplication().delegate as! AppDelegate).memes.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        tableView.reloadData()
        
       // self.navigationController?.navigationBar.hidden = true
       // self.tabBarController?.tabBar.hidden = true
        
    }
    

    override func viewWillAppear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        tableView.reloadData()
//        self.navigationController?.navigationBar.hidden = false
//        self.tabBarController?.tabBar.hidden = false
    }

 
 

}
