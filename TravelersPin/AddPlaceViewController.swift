//
//  AddPlaceViewController.swift
//  TravelersPin
//
//  Created by Chris Kong on 11/21/15.
//  Copyright © 2015 Chris Kong. All rights reserved.
//

import UIKit
import RealmSwift
import CloudKit
import MobileCoreServices
import CoreLocation

class AddPlaceViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
  // MARK: Outlets

  @IBOutlet weak var photoImageView: UIImageView!
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var addressTextField: UITextField!
  @IBOutlet weak var commentTextField: UITextField!
  @IBOutlet weak var ratingControl: RatingControl!
  @IBOutlet weak var saveButton: UIBarButtonItem!
  
  // MARK: Properties
  
  let container = CKContainer.defaultContainer()
  var publicDatabase: CKDatabase?
  // confirm?
  var currentRecord: CKRecord?
  var photoURL: NSURL?
  
  // location property
  var currentLocation: CLLocation?
  
  // MARK: View Controller Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Handle the text field’s user input through delegate callbacks
    nameTextField.delegate = self
    addressTextField.delegate = self
    commentTextField.delegate = self
    
    // Enable the Save button only if the text field has a valid Place name
    checkValidNameAndLocation()
    
    // CloudKit container
    publicDatabase = container.publicCloudDatabase
  }
  
  // MARK: UITextFieldDelegate
  
  func textFieldShouldReturn(textField: UITextField) -> Bool
  {
    // Hide the keyboard
    textField.resignFirstResponder()
    return true
  }
  
  // check?

  func textFieldDidBeginEditing(textField: UITextField)
  {
    // Disable the Save button while editing
    // saveButton.enabled = false
  }
  
  func textFieldDidEndEditing(textField: UITextField)
  {
    checkValidNameAndLocation()
    navigationItem.title = nameTextField.text
  }
  
  func checkValidNameAndLocation()
  {
    // Disable the Save button if the text field is empty
    let nameText = nameTextField.text ?? ""
    let addressText = addressTextField.text ?? ""
    saveButton.enabled = !nameText.isEmpty && !addressText.isEmpty
  }
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
  {
    nameTextField.endEditing(true)
    addressTextField.endEditing(true)
    commentTextField.endEditing(true)
  }
  
  // MARK: UIImagePickerControllerDelegate
  
  func imagePickerControllerDidCancel(picker: UIImagePickerController)
  {
    // Dismiss the picker if the user canceled
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
  {
    // The info dictionary contains multiple representations of the image, and this uses the original
    let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage

    // Set photoImageView to display the selected image
    photoImageView.image = selectedImage
    
    // CloudKit Method
    photoURL = saveImageToFile(selectedImage)

    // Dismiss the picker
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  // MARK: Navigation
  
  @IBAction func cancel(sender: UIBarButtonItem)
  {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
//  @IBAction func saveAction(sender: UIBarButtonItem)
//  {
//    savePlace()
//    saveRecordToCloud(self)
//    self.navigationController?.popToRootViewControllerAnimated(true)
//  }
//  // This method lets you configure a view controller before it's presented
//  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
  {
    if saveButton === sender
    {
      savePlace()
      saveRecordToCloud(self)
    }
  }

  // MARK: Actions
  
  @IBAction func selectImageFromPhotoLibrary(sender: UITapGestureRecognizer)
  {
    // Hide the keyboard
    nameTextField.resignFirstResponder()
    addressTextField.resignFirstResponder()
    commentTextField.resignFirstResponder()
    
    // UIImagePickerController is a view controller that lets a user pick media from their photo library
    let imagePickerController = UIImagePickerController()
    
    // Only allow photos to be picked, not taken
    imagePickerController.sourceType = .PhotoLibrary
    
    // Make sure ViewController is notified when the user picks an image
    imagePickerController.delegate = self
    
    presentViewController(imagePickerController, animated: true, completion: nil)
  }
  
  func savePlace()
  {
    let newPlace = PlaceItem()
    newPlace.name = nameTextField.text!
    newPlace.address = addressTextField.text!
    newPlace.comment = commentTextField.text!
    newPlace.photo = UIImagePNGRepresentation(photoImageView.image!)
    newPlace.rating = ratingControl.rating
    
    PlaceDataController.savePlace(newPlace)
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
    if (photoURL == nil)
    {
      notifyUser("No Photo", message: "Use the Photo option to choose a photo")
    }
    
    let asset = CKAsset(fileURL: photoURL!)
    
    let myRecord = CKRecord(recordType: "Places")
    myRecord.setObject(nameTextField.text, forKey: "name")
    myRecord.setObject(addressTextField.text, forKey: "address")
    myRecord.setObject(commentTextField.text, forKey: "comment")
    myRecord.setObject(asset, forKey: "photo")
    myRecord.setObject(ratingControl.rating, forKey: "rating")
    
    // GeoCoder Method
    
    let geocoder = CLGeocoder()
    geocoder.geocodeAddressString(addressTextField.text!, completionHandler:
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
          print("Error, error")
        }
        
        myRecord.setObject(self.currentLocation, forKey: "location")
        
        self.publicDatabase!.saveRecord(myRecord, completionHandler:
          ({ returnRecord, error in
            if let err = error
            {
              self.notifyUser("Save Error", message: err.localizedDescription)
            }
            else {
              dispatch_async(dispatch_get_main_queue())
              {
                // self.notifyUser("Success", message: "Successfully saved")
              }
              // keep?
              self.currentRecord = myRecord
            }
          }))
        
        
      })
    
    // Original Save Method
    
//    publicDatabase!.saveRecord(myRecord, completionHandler:
//      ({returnRecord, error in
//        if let err = error
//        {
//          self.notifyUser("Save Error", message: err.localizedDescription)
//        }
//        else {
//          dispatch_async(dispatch_get_main_queue())
//          {
//            self.notifyUser("Success", message: "Place saved successfully")
//          }
//          // confirm?
//          self.currentRecord = myRecord
//        }
//      }))
  }
  
  func notifyUser(title: String, message: String) -> Void
  {
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
    
    let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
    
    alert.addAction(cancelAction)
    self.presentViewController(alert, animated: true, completion: nil)
  }
  
  
}

//CLLocationManagerDelegate
//{
//  @IBOutlet weak var imageView: UIImageView!
//  @IBOutlet weak var nameTextField: UITextField!
//  @IBOutlet weak var addressTextField: UITextField!



//  @IBAction func saveAction(sender: UIBarButtonItem)
//  {

//
//    let asset = CKAsset(fileURL: photoURL!)
//    let myRecord = CKRecord(recordType: "Album")
//    
//    myRecord.setObject(nameTextField.text, forKey: "name")
//    myRecord.setObject(addressTextField.text, forKey: "address")
//    myRecord.setObject(asset, forKey: "photo")
//    
//    // The Other Method
//    
//    let geocoder = CLGeocoder()
//    geocoder.geocodeAddressString(addressTextField.text!, completionHandler:
//      {(placemarks, error) -> Void in
//        if (error == nil)
//        {
//          if placemarks!.count > 0
//          {
//            let placemark: CLPlacemark = placemarks![0]
//            self.currentLocation = placemark.location
//          }
//        }
//        else {
//          print("Error", error)
//        }
//        
//        myRecord.setObject(self.currentLocation, forKey: "location")
//        
//        self.publicDatabase!.saveRecord(myRecord, completionHandler:
//          ({ returnRecord, error in
//            if let err = error
//            {
//              self.notifyUser("Save Error", message: err.localizedDescription)
//            }
//            else {
//              dispatch_async(dispatch_get_main_queue())
//                {
//                  self.notifyUser("Success", message: "Successfully saved")
//              }
//              self.currentRecord = myRecord
//            }
//          }))
//
//    })
//    

//  }
//  
//}