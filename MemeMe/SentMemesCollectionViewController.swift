//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Hugo Adolfo Perez Solorzano on 22/05/15.
//  Copyright (c) 2015 bmgh. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate  {
    
    var memes: [Meme]!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        memes = appDelegate.memes
        
        // After popViewControllerAnimated is called from the
        // Meme Editor, the same table view is displayed without
        // the new memed image added.
        // Execute reload data to force a reload,
        // but only does so if there are new meme sent
        // to improve performance.
        // Reload is not needed if user has not shared any new meme.
        if collectionView.numberOfItemsInSection(0) != memes.count {
            collectionView.reloadData()
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = self.memes[indexPath.row]
        
        // Set the name and image
        //cell.nameLabel.text = villain.name
        cell.memedImageView.image = meme.memedImage
        //cell.schemeLabel.text = "Scheme: \(villain.evilScheme)"
        return cell
    }
    
    // When an image is selected, go to the detail controller
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath)
    {
        let detailVC = self.storyboard?.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailVC.meme = self.memes[indexPath.row]
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
}
