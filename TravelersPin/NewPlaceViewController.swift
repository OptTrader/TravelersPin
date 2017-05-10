//
//  NewPlaceViewController.swift
//  TravelersPin
//
//  Created by Chris Kong on 1/15/16.
//  Copyright © 2016 Chris Kong. All rights reserved.
//

import UIKit
import CloudKit
import MobileCoreServices
import CoreLocation

class NewPlaceViewController: BaseViewController, UITextFieldDelegate, UITextViewDelegate
{
  // MARK: Properties

  @IBOutlet weak var backgroundImageView: UIImageView!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var nameTextField: MKTextField!
  @IBOutlet weak var addressTextField: MKTextField!
  @IBOutlet weak var nameView: UIView!
  @IBOutlet weak var addressView: UIView!
  @IBOutlet weak var ratingControl: RatingControl!
  @IBOutlet weak var commentTextView: UITextView!
  @IBOutlet weak var saveButton: UIBarButtonItem!

  let container = CKContainer.defaultContainer()
  var publicDatabase: CKDatabase?
  
  // Image Properties
  var image: UIImage?
  var photoURL: NSURL?
  
  // Location Property
  var currentLocation: CLLocation?

  // MARK: View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // View Appearance
    setupView()
    
    // Handle the text field’s user input through delegate callbacks
    nameTextField.delegate = self
    addressTextField.delegate = self
    commentTextView.delegate = self
    
    // Enable the Save button only if the text field has a valid name and address
    checkValidNameAndAddress()
    
    // CloudKit container
    publicDatabase = container.publicCloudDatabase
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(true)
    
    nameTextField.becomeFirstResponder()
  }
  
  // MARK: Configuration
  
  private func setupView()
  {
    // Load imageView from camera or library
    backgroundImageView.image = image
    imageView.image = image

    // Apply blurring effect    
    let blurEffect = UIBlurEffect(style: .Dark)
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.frame = view.bounds
    backgroundImageView.addSubview(blurEffectView)
    
    // Load rating control
    ratingControl.rating = 3
    
    // Change the navigation bar's appearance
    UINavigationBar.appearance().barTintColor = UIColor.blackColor()
    UINavigationBar.appearance().tintColor = UIColor.whiteColor()
    
    if let barFont = UIFont(name: "Avenir-Light", size: 20.0)
    {
      UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: barFont]
    }
    
    // Looks for single or multiple taps
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(NewPlaceViewController.dismissKeyboard))
    view.addGestureRecognizer(tap)
    
    // Pull up keyboard at initial view
    nameTextField.becomeFirstResponder()
    
    // Name & Address Text Fields Apprearances
    nameTextField.layer.borderColor = UIColor.clearColor().CGColor
    nameTextField.floatingPlaceholderEnabled = false
    nameTextField.tintColor = UIColor.MKColor.LightGreen
    nameTextField.rippleLayerColor = UIColor.MKColor.LightGreen
    nameTextField.rippleLocation = .Right
    nameTextField.cornerRadius = 5.0
    nameTextField.bottomBorderEnabled = false

    addressTextField.layer.borderColor = UIColor.clearColor().CGColor
    addressTextField.floatingPlaceholderEnabled = false
    addressTextField.tintColor = UIColor.MKColor.LightGreen
    addressTextField.rippleLayerColor = UIColor.MKColor.LightGreen
    addressTextField.rippleLocation = .Right
    addressTextField.cornerRadius = 5.0
    addressTextField.bottomBorderEnabled = false
    
    // TextView Appearance
    commentTextView.text = "Share comment/tips (optional)"
    commentTextView.textColor = UIColor.lightGrayColor()
  }
  
  // MARK: UITextFieldDelegate
  
  func textFieldShouldReturn(textField: UITextField) -> Bool
  {
    // Hide the keyboard
    textField.resignFirstResponder()
    return true
  }
  
  func textFieldDidBeginEditing(textField: UITextField)
  {
    // Disable the Save button while editing
    saveButton.enabled = false
  }
  
  func textFieldDidEndEditing(textField: UITextField)
  {
    checkValidNameAndAddress()
    navigationItem.title = nameTextField.text
  }
 
  // MARK: UITextViewDelegate
  
  func textViewDidBeginEditing(textView: UITextView)
  {
    if (textView.text! == "Share comment/tips (optional)")
    {
      textView.text = ""
      textView.textColor = UIColor.lightGrayColor()
    }
    textView.becomeFirstResponder()
  }
  
  func textViewDidEndEditing(textView: UITextView)
  {
    if (textView.text! == "")
    {
      textView.text = "Share comment/tips (optional)"
      textView.textColor = UIColor.lightGrayColor()
    }
    textView.resignFirstResponder()
  }
  
  // MARK: Actions
  
  func checkValidNameAndAddress()
  {
    // Disable the Save button if the text field is empty
    let nameText = nameTextField.text ?? ""
    let addressText = addressTextField.text ?? ""
    saveButton.enabled = !nameText.isEmpty && !addressText.isEmpty
  }
  
  // Calls this function when the tap is recognized
  func dismissKeyboard()
  {
    // Causes the view (or one of its embedded text fields) to resign the first responder status
    view.endEditing(true)
  }
  
  func saveImageToFile(image: UIImage) -> NSURL
  {
    let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
    let docsDir: AnyObject = dirPaths[0]
    let filePath = docsDir.stringByAppendingPathComponent("currentImage.png")
    UIImageJPEGRepresentation(image, 0.5)?.writeToFile(filePath, atomically: true)
    
    return NSURL.fileURLWithPath(filePath)
  }
  
  func saveRecordToCloud(sender: AnyObject)
  {
    if (self.photoURL == nil)
    {
      self.presentMessage("No Photo", message: "Use the Photo option to choose a photo")
    }
    
    let asset = CKAsset(fileURL: self.photoURL!)
    
    let myRecord = CKRecord(recordType: "Places")
    myRecord.setObject(self.nameTextField.text, forKey: "name")
    myRecord.setObject(self.addressTextField.text, forKey: "address")
    
    if (self.commentTextView.text! == "Share comment/tips (optional)")
    {
      self.commentTextView.text = ""
    }
    
    myRecord.setObject(self.commentTextView.text, forKey: "comment")
    myRecord.setObject(asset, forKey: "photo")
    myRecord.setObject(self.ratingControl.rating, forKey: "rating")
    
    // GeoCoder Method
    
    let geocoder = CLGeocoder()
    geocoder.geocodeAddressString(self.addressTextField.text!, completionHandler:
      {(placemarks, error) -> Void in
        
        if (error == nil)
        {
          if placemarks!.count > 0
          {
            let placemark: CLPlacemark = placemarks![0]
            self.currentLocation = placemark.location
          }
        }
        else {
          self.presentMessage("Save Error", message: "There is a problem with the address. Please try again.")
          return
        }
        
        myRecord.setObject(self.currentLocation, forKey: "location")
        
        self.publicDatabase!.saveRecord(myRecord, completionHandler:
        ({ returnRecord, error in
          if let err = error
          {
            self.presentMessage("Save Error", message: err.localizedDescription)
            return
          }
          else {
            dispatch_async(dispatch_get_main_queue())
            {
              
            }      
          }
        }))
    })
    
  }

  
  @IBAction func saveAction(sender: UIBarButtonItem)
  {
    AccountService.accountStatus { available in
      if available == true
      {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
          self.photoURL = self.saveImageToFile(self.image!)
          self.saveRecordToCloud(self)
          
          // Dismiss the view controller
          self.dismissViewControllerAnimated(true, completion: nil)
        })
      }
      else {
        self.presentMessage("You're not logged in", message: "Please go to iCloud settings and log in with your credentials to save photo.")
      }
    }
  
  }
  
  // MARK: Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  
  @IBAction func cancelAction(sender: UIBarButtonItem)
  {
    dismissViewControllerAnimated(true, completion: nil)
  }
    
}