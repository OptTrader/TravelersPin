//
//  AddPlaceViewController.swift
//  TravelersPin
//
//  Created by Chris Kong on 11/21/15.
//  Copyright © 2015 Chris Kong. All rights reserved.
//

import UIKit
import RealmSwift

class AddPlaceViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
  // MARK: Properties

  @IBOutlet weak var photoImageView: UIImageView!
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var locationTextField: UITextField!
  @IBOutlet weak var commentTextField: UITextField!
  @IBOutlet weak var ratingControl: RatingControl!
  @IBOutlet weak var saveButton: UIBarButtonItem!
  
  // MARK: View Controller Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Handle the text field’s user input through delegate callbacks
    nameTextField.delegate = self
    locationTextField.delegate = self
    commentTextField.delegate = self
    
    // Enable the Save button only if the text field has a valid Place name
    checkValidNameAndLocation()
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
    let locationText = locationTextField.text ?? ""
    saveButton.enabled = !nameText.isEmpty && !locationText.isEmpty
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

    // Dismiss the picker
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  // MARK: Navigation
  
  @IBAction func cancel(sender: UIBarButtonItem)
  {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  // This method lets you configure a view controller before it's presented
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
  {
    if saveButton === sender
    {
      savePlace()
    }
  }

  // MARK: Actions
  
  @IBAction func selectImageFromPhotoLibrary(sender: UITapGestureRecognizer)
  {
    // Hide the keyboard
    nameTextField.resignFirstResponder()
    locationTextField.resignFirstResponder()
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
    newPlace.location = locationTextField.text!
    newPlace.comment = commentTextField.text!
    newPlace.photo = UIImagePNGRepresentation(photoImageView.image!)
    newPlace.rating = ratingControl.rating
    
    PlaceDataController.savePlace(newPlace)
  }
  
}