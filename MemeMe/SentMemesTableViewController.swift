//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Hugo Adolfo Perez Solorzano on 22/05/15.
//  Copyright (c) 2015 bmgh. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var memes: [Meme]!
    var noMemeAv: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        memes = appDelegate.memes
        
        // If no Meme go to Meme Editor
        if noMemeAv {
            noMemeAv = false
            if memes.count == 0 {
                performSegueWithIdentifier("AddMeme", sender: self)
            }
        }

        if tableView.numberOfRowsInSection(0) != memes.count {
            tableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableCell") as! UITableViewCell
        let meme = self.memes[indexPath.row]
        
        // Set the memed image and title
        cell.imageView?.image = meme.memedImage
        cell.textLabel?.text = meme.topText
        
        // If the cell has a detail label, we will provide
        if let detailTextLabel = cell.detailTextLabel {
            detailTextLabel.text = meme.bottomText
        }
        
        return cell
    }
    
    // When an image is selected, go to the detail controller
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detailViewController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailViewController.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailViewController, animated: false)
        
    }
    
}
