//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Javier Gomez on 7/5/16.
//  Copyright © 2016 Javier Gomez. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    var meme: Meme!
    
    @IBOutlet weak var detailedMemed: UIImageView!
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        self.detailedMemed.image = self.meme.imageMemed
        
        let editButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: #selector(MemeDetailViewController.editMethod))
        navigationItem.rightBarButtonItem = editButton
        
       // self.tabBarController?.tabBar.hidden = true
       // self.navigationController?.navigationBar.hidden = false
    }

    
    func editMethod()
    {
        let editViewCOntroller = self.storyboard?.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
        editViewCOntroller.meme = meme

        presentViewController(editViewCOntroller, animated: true, completion: nil)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
       // self.navigationController?.navigationBar.hidden = false
       // self.tabBarController?.tabBar.hidden = false

    }
}


