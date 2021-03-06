//
//  FavoriteDetailViewController.swift
//  TravelersPin
//
//  Created by Chris Kong on 11/21/15.
//  Copyright © 2015 Chris Kong. All rights reserved.
//

import UIKit
import RealmSwift
import Social
import MapKit

class FavoriteDetailViewController: BaseViewController, MKMapViewDelegate
{
  // MARK: Constants
  
  private struct Constants
  {
    static let PinIdentifier = "pin"
  }
  
  // MARK: Properties
  
  @IBOutlet private var backgroundImageView: UIImageView!
  @IBOutlet private var imageView: UIImageView!
  @IBOutlet weak var imageButton: MKButton!
  @IBOutlet weak var mapButton: MKButton!
  @IBOutlet private var addressLabel: UILabel!
  @IBOutlet private var nameLabel: UILabel!
  @IBOutlet private var ratingControl: RatingControl!
  @IBOutlet private var commentTextView: UITextView!
  @IBOutlet weak var shareButton: MKButton!
  @IBOutlet weak var backgroundMaskView: UIVisualEffectView!
  @IBOutlet weak var popoverMapView: UIView!
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var popoverImage: UIView!
  @IBOutlet weak var popoverPicture: UIImageView!
  @IBOutlet weak var maskButton: MKButton!
  
  var place: PlaceItem?

  // MARK: View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupView()
    
    // MapView's Delegate
    mapView.delegate = self
    
    // Place Pin
    placePin()
  }
  
  // MARK: Configuration
  
  private func setupView()
  {
    // Change navigation bar's appearance
    let nav = self.navigationController?.navigationBar
    nav?.translucent = true
    nav?.shadowImage = UIImage()
    nav?.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
    nav?.tintColor = UIColor.whiteColor()
    
    // Add MaterialKit Attributes
    shareButton.maskEnabled = false
    shareButton.ripplePercent = 1.75
    shareButton.rippleLayerColor = UIColor.MKColor.Grey
    shareButton.backgroundAniEnabled = false
    shareButton.rippleLocation = .Center
    
    // MapView's Appearance
    mapView.showsPointsOfInterest = true
    mapView.showsBuildings = true
    mapView.showsCompass = true
    mapView.showsScale = true
    mapView.showsTraffic = true
    
    // MapView's Current Region
    let theSpan = MKCoordinateSpanMake(1, 1)
    let location = CLLocationCoordinate2DMake(Double((place?.latitude)!), Double((place?.longitude)!))
    let theRegion = MKCoordinateRegionMake(location, theSpan)
    mapView.setRegion(theRegion, animated: true)
    
    if let place = place
    {
      // Apply blurring effect
      self.backgroundImageView.image = UIImage(data: place.photo!)
      let blurEffect = UIBlurEffect(style: .Dark)
      let blurEffectView = UIVisualEffectView(effect: blurEffect)
      blurEffectView.frame = view.bounds
      self.backgroundImageView.addSubview(blurEffectView)
      
      self.imageView.image = UIImage(data: place.photo!)
      self.popoverPicture.image = UIImage(data: place.photo!)
      self.addressLabel.text = place.address
      self.nameLabel.text = place.name
      self.ratingControl.rating = place.rating
      self.commentTextView.text = place.comment
    }
  }
  
  // MARK: Actions
  
  @IBAction func mapAction(sender: MKButton)
  {
    backgroundMaskView.hidden = false
    showMask()
    popoverMapView.hidden = false
    let scale = CGAffineTransformMakeScale(0.5, 0.5)
    let translate = CGAffineTransformMakeTranslation(0, -200)
    popoverMapView.transform = CGAffineTransformConcat(scale, translate)
    popoverMapView.alpha = 0
    
    spring(0.5)
    {
      let scale = CGAffineTransformMakeScale(1, 1)
      let translate = CGAffineTransformMakeTranslation(0, 0)
      self.popoverMapView.transform = CGAffineTransformConcat(scale, translate)
      self.popoverMapView.alpha = 1
    }
  }

  func placePin()
  {
    let location = CLLocationCoordinate2DMake(Double(place!.latitude), Double(place!.longitude))
    let dropPin = FavoritesCustomPointAnnotation(place: self.place!)
    dropPin.pinCustomImageName = "customPin"
    dropPin.coordinate = location
    dropPin.title = place!.title
    dropPin.subtitle = place!.subtitle
    dropPin.name = place!.name
    dropPin.image = UIImage(data: place!.photo!)
    mapView.addAnnotation(dropPin)
  }
  
  @IBAction func imageAction(sender: MKButton)
  {
    backgroundMaskView.hidden = false
    showMask()
    popoverImage.hidden = false
    let scale = CGAffineTransformMakeScale(0.5, 0.5)
    let translate = CGAffineTransformMakeTranslation(0, -200)
    popoverImage.transform = CGAffineTransformConcat(scale, translate)
    popoverImage.alpha = 0
    
    spring(0.5)
    {
      let scale = CGAffineTransformMakeScale(1, 1)
      let translate = CGAffineTransformMakeTranslation(0, 0)
      self.popoverImage.transform = CGAffineTransformConcat(scale, translate)
      self.popoverImage.alpha = 1
    }
  }
  
  func hidePopoverImage()
  {
    spring(0.5)
    {
      self.popoverImage.transform = CGAffineTransformMakeTranslation(0, 0)
      self.popoverImage.hidden = true
      self.backgroundMaskView.hidden = true
    }
  }
  
  func hidePopoverMapView()
  {
    spring(0.5)
    {
      self.popoverMapView.transform = CGAffineTransformMakeTranslation(0, 0)
      self.popoverMapView.hidden = true
      self.backgroundMaskView.hidden = true
    }
  }
  
  func showMask()
  {
    self.maskButton.hidden = false
    self.maskButton.alpha = 0
    spring(0.5)
    {
      self.maskButton.alpha = 1
    }
  }
  
  @IBAction func maskButtonAction(sender: MKButton)
  {
    spring(0.5)
    {
      self.maskButton.alpha = 0
    }
    
    hidePopoverImage()
    hidePopoverMapView()
  }
  
  @IBAction func shareAction(sender: MKButton)
  {
    let actionSheet = UIAlertController(title: "", message: "Share Your Favorite Place", preferredStyle: UIAlertControllerStyle.ActionSheet)
    
    // Configure a new action to share image on Facebook
    let facebookPostAction = UIAlertAction(title: "Share on Facebook", style: UIAlertActionStyle.Default) { (action) -> Void in
      
      if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook)
      {
        let facebookComposeVC = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        facebookComposeVC.addImage(self.imageView.image)
        
        self.presentViewController(facebookComposeVC, animated: true, completion: nil)
      }
      else {
        self.presentMessage("Try Again", message: "You are not connected to your Facebook account.")
      }
    }
    
    // Configure a new action for sharing image on Twitter
    let tweetPostAction = UIAlertAction(title: "Share on Twitter", style: UIAlertActionStyle.Default) { (action) -> Void in
      
      // Check if sharing to Twitter is possible
      if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter)
      {
        let twitterComposeVC = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        twitterComposeVC.addImage(self.imageView.image)
        
        self.presentViewController(twitterComposeVC, animated: true, completion: nil)
      }
      else {
        self.presentMessage("Try Again", message: "You are not logged in to your Twitter account.")
      }
    }
    
    // Configure a new action for sharing image on Sina Weibo
    let sinaWeiboPostAction = UIAlertAction(title: "Share on Sina Weibo", style: UIAlertActionStyle.Default) { (action) -> Void in
      
      // Check if sharing to Sina Weibo is possible
      if SLComposeViewController.isAvailableForServiceType(SLServiceTypeSinaWeibo)
      {
        let weiboComposeVC = SLComposeViewController(forServiceType: SLServiceTypeSinaWeibo)
        weiboComposeVC.addImage(self.imageView.image)
        
        self.presentViewController(weiboComposeVC, animated: true, completion: nil)
      }
      else {
        self.presentMessage("Try Again", message: "You are not logged in to your Sina Weibo.")
      }
    }
    
    // Configure a new action to show the UIActivityViewController
    let moreAction = UIAlertAction(title: "More", style: UIAlertActionStyle.Default) { (action) -> Void in
      
      let activityViewController = UIActivityViewController(activityItems: [self.imageView.image!], applicationActivities: nil)
      activityViewController.excludedActivityTypes = [UIActivityTypeMail]
      
      self.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    let dismissAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.Cancel) { (action) -> Void in
    }
    
    actionSheet.addAction(facebookPostAction)
    actionSheet.addAction(tweetPostAction)
    actionSheet.addAction(sinaWeiboPostAction)
    actionSheet.addAction(moreAction)
    actionSheet.addAction(dismissAction)
    
    presentViewController(actionSheet, animated: true, completion: nil)
  }
  
  // MARK: MKMapViewDelegate
  
  func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?
  {
    if !(annotation is FavoritesCustomPointAnnotation)
    {
      return nil
    }
    
    // Reuse the annotation if possible
    var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(Constants.PinIdentifier)
    
    if pinView == nil
    {
      pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: Constants.PinIdentifier)
      pinView?.canShowCallout = true
    }
      
    else {
      pinView?.annotation = annotation
    }
    
    // Set property after
    let cpa = annotation as! FavoritesCustomPointAnnotation
    if cpa.image != nil
    {
      UIGraphicsBeginImageContext(CGSize(width: 50, height: 50))
      cpa.image!.drawInRect(CGRectMake(0, 0, 50, 50))
      let smallImage = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      let imView = UIImageView(image: smallImage)
      pinView?.leftCalloutAccessoryView = imView
    }
    
    pinView!.image = UIImage(named: cpa.pinCustomImageName)
    
    return pinView
  }

}