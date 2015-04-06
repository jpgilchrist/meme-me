//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by James Gilchrist on 3/31/15.
//  Copyright (c) 2015 James Gilchrist. All rights reserved.
//

import UIKit
import CoreData

class SentMemesTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var memes = [Meme]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //we load the memes from core data on view will appear to make sure they are fresh 
        //especially after a meme has just been created or edited.
        loadMemesFromCoreData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //redirect to the MemeEditor because there are no memes to select
        if self.memes.count == 0 {
            self.performSegueWithIdentifier("ShowMemeEditorFromTable", sender: nil)
        }
    }
    
    //load the memes from CoreData and reload the table
    func loadMemesFromCoreData() {
        let appDelegate =
        UIApplication.sharedApplication().delegate as AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName: "Meme")
        var error: NSError?
        
        let fetchedResults =
        managedContext.executeFetchRequest(fetchRequest,
            error: &error) as [Meme]?
        
        if let results = fetchedResults {
            self.memes = results
            self.tableView.reloadData()
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //deque a custom SentMemeTableViewCell
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableCell", forIndexPath: indexPath) as SentMemeTableViewCell
        
        //setup the image for the SentMemeTableViewCell
        cell.memedImageView.image = UIImage(data: memes[indexPath.row].memedImageData)
        
        return cell
    }
    
    //perfor segue and send meme when a table item is selcted
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("ShowMemeDetailFromTable", sender: memes[indexPath.row])
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //unwrap the sender as a meme and assign it to the destinationViewController
        if let meme = sender as? Meme {
            if let dvc = segue.destinationViewController as? MemeEditorViewController {
                dvc.meme = meme
            } else if let dvc = segue.destinationViewController as?  MemeDetailViewController {
                dvc.meme = meme
            }
        }
    }


}
