//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by James Gilchrist on 3/31/15.
//  Copyright (c) 2015 James Gilchrist. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        loadMemesFromAppDelegate()
    }
    
    func loadMemesFromAppDelegate() {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.memes = appDelegate.memes
        
        println("Loaded Memes \(self.memes)")
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println("number of rows in section \(section) \(self.memes.count)")
        return self.memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        println("Cell for Row at \(indexPath.row)")
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableCell", forIndexPath: indexPath) as SentMemeTableViewCell
        
        cell.topTextLabel.text = self.memes[indexPath.row].topText
        cell.bottomTextLabel.text = self.memes[indexPath.row].bottomText
        cell.memedImageView.image = self.memes[indexPath.row].memedImage
        
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
