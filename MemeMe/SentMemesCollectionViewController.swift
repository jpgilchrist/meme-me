//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by James Gilchrist on 4/3/15.
//  Copyright (c) 2015 James Gilchrist. All rights reserved.
//

import UIKit
import CoreData

class SentMemesCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var memes = [Meme]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //we load the memes from CoreData on view will appear to make sure they are fresh
        //especially after a meme has just been created or edited.
        loadMemesFromCoreData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
        //redirect to the MemeEditor because there are no memes to select
        if self.memes.count == 0 {
            self.performSegueWithIdentifier("ShowMemeEditorFromCollection", sender: nil)
        }
    }
    
    //load the memes from CoreData and reload the collection
    //NOTE: this is almsot a duplicate from SentMemesTableViewController except for the fact that we are reloading 
    //      the collection view, not the tableView. We could definitely reduce code redundancy here.
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
            self.collectionView.reloadData()
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        //using the default UICollectionViewCell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionCell", forIndexPath: indexPath) as UICollectionViewCell
        
        //setup a UIImageView to set as the background view
        let imageView = UIImageView(image: UIImage(data: memes[indexPath.row].memedImageData))
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.backgroundColor = UIColor.lightGrayColor()

        cell.backgroundView = imageView
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    
        // calculate the size of each cell based on the size/aspect ratio of the screen/images
        return calculateCellDimensionsForIndexPath(indexPath)
        
    }
    
    //cells will be the same aspect ratio as the subject memedImage and will fit 3 wide on any screen
    func calculateCellDimensionsForIndexPath(indexPath: NSIndexPath) -> CGSize {
        let memedImage = UIImage(data: memes[indexPath.row].memedImageData)!
        let aspectRatio = memedImage.size.width / memedImage.size.height
        
        let screenWidth = collectionView.bounds.size.width
        //oritinally (screenWidth - 40) / 3, but specifying exact dimensions to fit 3 wide with spacing of 10
        //resulted in some screens still only displaying 2. Therefore, I provided a little wiggle room.
        let cellWidth =  (screenWidth - 50) / 3
        let cellHeight = cellWidth / aspectRatio
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        //keep a border of 10.0 on left and right of collectionView
        return UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("ShowMemeDetailFromCollection", sender:  memes[indexPath.row])
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //setup the controllers meme data object
        if segue.identifier == "ShowMemeDetailFromCollection" {
            if let meme = sender as? Meme {
                let dvc = segue.destinationViewController as MemeDetailViewController
                dvc.meme = meme
                
            }
        }
        
    }
    

}
