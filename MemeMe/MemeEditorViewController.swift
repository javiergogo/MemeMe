//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Javier Gomez on 6/30/16.
//  Copyright © 2016 Javier Gomez. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var sharingButton: UIBarButtonItem!
    @IBOutlet weak var textTop: UITextField!
    @IBOutlet weak var textBottom: UITextField!
    
    @IBOutlet weak var topBar: UIToolbar!
    @IBOutlet weak var bottomBar: UIToolbar!
    
    var meme: Meme!
    
    //Hide status bar
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        //Susbscribe to any movement (notification)
        subscribeToKeyboardNotification()
        subscribeToKeyboardNotificationHiding()
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        unsubscribeFromKeyboardNotificationsHiding()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sharingButton.enabled = false
        
        textTop.delegate = self
        textBottom.delegate = self
        
        if meme != nil
        {
            textTop.text = meme.textTop
            textBottom.text = meme.textBottom
            imagePickerView.image = meme.imageOriginal
        }
        
        //Call function for format text in the textfield
        textTop = formatText(textTop!)
        textBottom = formatText(textBottom!)
    }
    
    //Function that gives format to the text in text field
    func formatText(textforFormating:UITextField) -> UITextField
    {
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "Impact", size: 40)!,
            NSStrokeWidthAttributeName : -4.5
        ]
        textforFormating.defaultTextAttributes = memeTextAttributes
        textforFormating.textAlignment = NSTextAlignment.Center
        
        return textforFormating
    }

    //#MARK: Image/camera management
    //Picking image from library
    @IBAction func pickImage(sender: AnyObject) {
        pickingImage(.Camera)
    }
    //Picking image from CAMERA
    @IBAction func pickImageAlbum(sender: AnyObject) {
        pickingImage(.PhotoLibrary)
    }
    //User selected type of source (camera or album)
    func pickingImage(typeofSource: UIImagePickerControllerSourceType)
    {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = typeofSource
        presentViewController(pickerController, animated: true, completion: nil)
    }
    //Showing picked image in UIImageView
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            imagePickerView.image = image
            sharingButton.enabled = true
        }
        view.bringSubviewToFront(textTop)
        view.bringSubviewToFront(textBottom)

        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //#MARK: Keyboards functions
    //Gets subscribed when appered (WILLAPEAR) to any notification, call function keyboardwillhide
    func subscribeToKeyboardNotificationHiding ()
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    //When keyboard will hide (it is a notification) ask if is bottom getting the focus if it is true makes 0 the origin of the app
    func keyboardWillHide(notification: NSNotification) {
        if textBottom.isFirstResponder()
        {
            view.frame.origin.y = 0
        }
    }
    //Quit to the subscription so wont use after change of screen, gets called in (viewWillDisappear)
    func unsubscribeFromKeyboardNotificationsHiding()
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    //Keyboard WILL SHOW
    //Gets subscribed when appered
    func subscribeToKeyboardNotification ()
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillShow(_:))    , name: UIKeyboardWillShowNotification, object: nil)
    }
    //When keyboard will show (it is a notification) ask if is bottom getting the focus if it is true calls getKeyboardheight
    //and moves the screen up (the size of the keyboard)
    func keyboardWillShow(notification: NSNotification) {
        if textBottom.isFirstResponder()
        {
            view.frame.origin.y = getKeyboardHeight(notification) * -1
        }
    }
    func unsubscribeFromKeyboardNotifications()
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
    
    //WILLSHOW and WILLHIDE share this function for getting the size of the keyboard
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    //When touch button return will stop editing text
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    //When touches outside of keyboard will stop editing text
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }

    //#MARK: Sharing methods
    //Sharing button
    @IBAction func sharingButton(sender: AnyObject)
    {
        //Beside of asign image and validate, call the function generateMemedImage, to generate a combinated image
        if let image:UIImage = generateMemedImage()
        {
            //Send the memedImage in a controller to use in the next controller for message or sharing in general
            let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            self.presentViewController(controller, animated: true, completion: nil)
            
            controller.completionWithItemsHandler = { activity, success, items, error in
                if success
                {   //send memedimage to the function save in case of having success (in controller)
                    self.save(image)
                    self.performSegueWithIdentifier("showSentMemes", sender: self)
                }
            }
        }
    }
    
    //#MARK: Adjusting image
    //Save memedimage, original image, both texts in a struct called Meme
    func save(memedImage: UIImage)
    {
        //Create the meme
        let meme = Meme(textTop: textTop.text!, textBottom: textBottom.text!, imageOriginal: imagePickerView.image!, imageMemed: memedImage)
        
        //Add it to the memes array in the Application Delegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        //The same
        //(UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
    }
    
    // Create a UIImage that combines the Image View and the Textfields
    func generateMemedImage() -> UIImage {
        
        topBar.hidden = true
        bottomBar.hidden = true
        
        // render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        topBar.hidden = false
        bottomBar.hidden = false
        
        return memedImage
    }
    

    //Clear textfields and image
    @IBAction func clearButton(sender: AnyObject) {
              
        dismissViewControllerAnimated(false, completion: nil)
        
        sharingButton.enabled = false
    }
    //Will clear text just the first time
    func textFieldDidBeginEditing(textField: UITextField) {
        if textTop.isFirstResponder() && textTop.text == "TOP"
        {
            textTop.text = ""
        }
        if textBottom.isFirstResponder() && textBottom.text == "BOTTOM"
        {
            textBottom.text = ""
        }
    }
}

