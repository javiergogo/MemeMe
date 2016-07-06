//
//  SentCollectionViewController.swift
//  MemeMe
//
//  Created by Javier Gomez on 7/5/16.
//  Copyright © 2016 Javier Gomez. All rights reserved.
//

import UIKit

class SentCollectionViewController: UICollectionViewController {

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //TODO: Implement flowLayout here.
        let space: CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3
        //let dimensionHeight = (self.view.frame.size.height)
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
        
        


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        collectionView.reloadData()
        return memes.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as! SentCollectionViewCell
        
        let meme = self.memes[indexPath.row]
        
        cell.imageCollectionViewCell.image = meme.imageMemed
    
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let detailedMemedController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        
        detailedMemedController.meme = self.memes[indexPath.row]
        self.navigationController?.pushViewController(detailedMemedController, animated: true)
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        collectionView?.reloadData()
        
        self.navigationController?.navigationBar.hidden = true
        self.tabBarController?.tabBar.hidden = true
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.hidden = false
        self.tabBarController?.tabBar.hidden = false
    }
    

}
