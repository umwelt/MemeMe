//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Hugo Adolfo Perez Solorzano on 22/05/15.
//  Copyright (c) 2015 bmgh. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar!
    
    
    var userEditedTopTextField: Bool!
    var userEditedBottomTextField: Bool!
    var memedImage: UIImage!
    
    override func viewWillAppear(animated: Bool) {
        // Disable camera button if camera is not available
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        self.subscribeTokeyboardNotifications()
        self.tabBarController?.tabBar.hidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if imageView.image == nil {
            shareButton.enabled = false
        }
        
        self.topTextField.delegate = self;
        self.bottomTextField.delegate = self;
        
        userEditedTopTextField = false
        userEditedBottomTextField = false
        
        self.formatTextFields()
        
    }
    
    
    func formatTextFields(){
        
        let memeTextAttributes = constructTextAttributes()
        
        topTextField.text = "TOP"
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = NSTextAlignment.Center
        
        bottomTextField.text = "BOTTOM"
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.textAlignment = NSTextAlignment.Center
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
        // Unhide tabBar
        self.tabBarController?.tabBar.hidden = false
    }
    
    // Construct the text attributes with font style and color
    func constructTextAttributes() -> [ NSObject : AnyObject ] {
        var textAttributes : [ NSObject : AnyObject] = [
            // Color for the outline of the characters
            NSStrokeColorAttributeName : UIColor.blackColor(),
            // Set foreground color
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            // Set stroke width (a negative value creates both fill and stroke)
            NSStrokeWidthAttributeName : -3
        ]
        if let font = UIFont(name: "HelveticaNeue-CondensedBlack", size: 40) {
            textAttributes[NSFontAttributeName] = font
        }
        return textAttributes
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Top text field tag == 0 
        // Bottom text field tag == 1
        if textField.tag == 0 {
            if !userEditedTopTextField {
                textField.text = ""
                userEditedTopTextField = true
            }
        }
        else if textField.tag == 1 {
            if !userEditedBottomTextField {
                textField.text = ""
                userEditedBottomTextField = true
            }
        }
    }
    
    // Hide the keyboard when user hits the return key
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Move the view upwards so the keyboard will not block the
    // bottom text field during edit.
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    // Move the view downwards when edit is completed
    func keyboardWillHide(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    // Get the keyboard height
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    // Subscribe to keyboard show/hide notification.
    // This is needed so that we know when to slide the view upwards.
    func subscribeTokeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // Unsubscribe the notifications.
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // Generate the memed image.
    func generateMemedImage() -> UIImage {
        // Hide toolbar and navbar
        navigationController?.navigationBar.hidden = true
        toolbar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        navigationController?.navigationBar.hidden = false
        toolbar.hidden = false
        
        return memedImage
    }
    
    // When an image is selected, set it in the editor screen, set the default text for top and bottom text field,
    // and enable share button.
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            topTextField.text = "TOP"
            bottomTextField.text = "BOTTOM"
            userEditedTopTextField = false
            userEditedBottomTextField = false
            shareButton.enabled = true
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    // User cancels the action from within the UIImagePickerController.
    // Dismiss the current controller.
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Create the Meme object and append it to the memes array in the Application Delegate
    func saveMeme() {
        var meme = Meme(topText: topTextField.text, bottomText: bottomTextField.text, originalImage: imageView.image!, memedImage: self.memedImage)
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
    }
    
    // Save Meme and dismiss view controller.
    func saveMemeAfterSaving(activity: String!, completed: Bool, items: [AnyObject]!, error: NSError!) {
        if completed {
            self.saveMeme()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // Action for the Share button
    @IBAction func shareMemedImage(sender: AnyObject) {
        self.memedImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [self.memedImage], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = saveMemeAfterSaving
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    // Action for the cancel button
    @IBAction func cancelPickAnImage(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // Action for the Camera button
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    // Action for the Album button
    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    

    
   
    

}

