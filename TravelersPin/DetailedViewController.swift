//
//  DetailedViewController.swift
//  TravelersPin
//
//  Created by Chris Kong on 12/16/15.
//  Copyright © 2015 Chris Kong. All rights reserved.
//

import UIKit

class DetailedViewController: BaseViewController
{
  // MARK: Properties
  
  @IBOutlet private var imageView: UIImageView!
  @IBOutlet private var addressLabel: UILabel!
  @IBOutlet private var ratingControl: RatingControl!
  @IBOutlet private var commentTextView: UITextView!
  @IBOutlet private var spinner: UIActivityIndicatorView!
  
  var place: Place?
  
  // MARK: View Controller's Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupView()
  }
  
  // MARK: Private
  
  private func setupView()
  {
    // Change navigation bar's appearance
    let nav = self.navigationController?.navigationBar
    nav?.translucent = true
    nav?.shadowImage = UIImage()
    nav?.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
    nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    nav?.tintColor = UIColor.whiteColor()
    
    if let place = place
    {
      navigationItem.title = place.name
      self.imageView.image = place.photo
      self.addressLabel.text = place.address
      self.ratingControl.rating = place.rating
      self.commentTextView.text = place.comment
    }
  }
  
//  private func shouldAnimatedIndicator(animate: Bool)
//  {
//    if animate
//    {
//      self.spinner.startAnimating()
//    } else {
//      self.spinner.stopAnimating()
//    }
//    
//    self.view.userInteractionEnabled = !animate
//    self.navigationController!.navigationBar.userInteractionEnabled = !animate
//  }

}
//
//import UIKit
//
//private let kUpdatedMessage = "City has been updated successfully"
//private let kUnwindSegue = "unwindToMainId"
//
//class DetailedViewController: BaseViewController {
//  
//  var city: City!
//  
//  @IBOutlet private var scrollView: UIScrollView!
//  @IBOutlet private var cityImageView: UIImageView!
//  @IBOutlet private var nameLabel: UILabel!
//  @IBOutlet private var descriptionTextView: UITextView!
//  @IBOutlet private var indicatorView: UIActivityIndicatorView!
//  
//  // MARK: Lifecycle
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    
//    setupView()
//    NSNotificationCenter.defaultCenter().addObserver(self, selector:Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
//  }
//  
//  // MARK: Private
//  private func setupView() {
//    self.cityImageView.image = self.city.image
//    self.nameLabel.text = self.city.name
//    self.descriptionTextView.text = self.city.text
//  }
//  
//  private func shouldAnimateIndicator(animate: Bool) {
//    if animate {
//      self.indicatorView.startAnimating()
//    } else {
//      self.indicatorView.stopAnimating()
//    }
//    
//    self.view.userInteractionEnabled = !animate
//    self.navigationController!.navigationBar.userInteractionEnabled = !animate
//  }
//  
//  func keyboardWillShow(notification: NSNotification) {
//    
//    let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)!.CGRectValue()
//    
//    let keyboardHeight = keyboardSize.height
//    let contentOffsetX = self.scrollView.contentOffset.x
//    let contentOffsetY = self.scrollView.contentOffset.y
//    
//    self.scrollView.contentOffset = CGPoint(x: contentOffsetX, y: contentOffsetY + keyboardHeight)
//  }
//  
//  // MARK: IBActions
//  @IBAction private func saveButtonDidPress(button:UIButton) {
//    view.endEditing(true)
//    
//    let identifier = city.identifier
//    let updatedText = descriptionTextView.text
//    
//    shouldAnimateIndicator(true)
//    CloudKitManager.updateRecord(identifier, text: updatedText) { [unowned self] (record, error) -> Void in
//      self.shouldAnimateIndicator(false)
//      if let error = error {
//        self.presentMessage(error.localizedDescription)
//      } else {
//        self.city.text = record.valueForKey(cityText) as! String
//        self.presentMessage(kUpdatedMessage)
//      }
//    }
//  }
//  
//  @IBAction private func removeButtonDidPress(button:UIButton) {
//    self.shouldAnimateIndicator(true)
//    CloudKitManager.removeRecord(self.city.identifier, completion: { [unowned self] (recordId, error) -> Void in
//      
//      self.shouldAnimateIndicator(false)
//      
//      if let error = error {
//        self.presentMessage(error.localizedDescription)
//      } else {
//        self.performSegueWithIdentifier(kUnwindSegue, sender: self)
//      }
//      })
//  }
//}
