//
//  MapViewController.swift
//  TravelersPin
//
//  Created by Chris Kong on 12/21/15.
//  Copyright © 2015 Chris Kong. All rights reserved.
//

import UIKit
import MapKit
import CloudKit

class MapViewController: BaseViewController, MKMapViewDelegate
{
  // MARK: Constants
  
  private struct Constants
  {
    static let PinIdentifier = "pin"
    static let SegueIdentifier = "showMapDetailedSegue"
  }
  
  // MARK: Properties
  
  @IBOutlet weak var mapView: MKMapView!
  
  var searchCompleted = false
  var queryOperation = CKQueryOperation()
  let timeDelay = 15.0
  
  private var places = [Place]()
  var annotation: CustomPointAnnotation? = nil
  var currentPlace: Place?
  var activityIndicatorView: NVActivityIndicatorView!
  
  // MARK: View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // MapView's Delegate
    mapView.delegate = self
    
    // View Appearance
    setupView()
    
    // Load contents
    updateData()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    // Navigation Bar Appearance
    navigationBarSetupView()
  }
  
  // MARK: Configuration
  
  private func setupView()
  {
    // Custom activity indicator
    let frame = CGRect(x: 0, y: 0, width: 30, height: 30)
    self.activityIndicatorView = NVActivityIndicatorView(frame: frame, type: .BallClipRotatePulse, color: UIColor.orangeColor(), padding: 30)
    self.activityIndicatorView.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2 - 150)
    self.view.addSubview(activityIndicatorView)
    
    // Refresh
    let refreshButton = MKButton()
    refreshButton.setImage(UIImage(named: "refresh"), forState: .Normal)
    refreshButton.frame = CGRectMake(0, 0, 25, 25)
    refreshButton.addTarget(self, action: #selector(MapViewController.refreshAction), forControlEvents: .TouchUpInside)
    refreshButton.maskEnabled = false
    refreshButton.ripplePercent = 1.75
    refreshButton.rippleLayerColor = UIColor.MKColor.Grey
    refreshButton.backgroundAniEnabled = false
    refreshButton.rippleLocation = .Center
    
    let leftBarButton = UIBarButtonItem()
    leftBarButton.customView = refreshButton
    self.navigationItem.leftBarButtonItem = leftBarButton
  }
  
  private func navigationBarSetupView()
  {
    // Change the navigation bar's appearance
    UINavigationBar.appearance().barTintColor = UIColor.blackColor()
    UINavigationBar.appearance().tintColor = UIColor.whiteColor()
    
    if let barFont = UIFont(name: "Avenir-Light", size: 20.0)
    {
      UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: barFont]
    }
  }
  
  // MARK: Actions
  
  func shouldAnimatedIndicator(animate: Bool)
  {
    if animate
    {
      self.activityIndicatorView.startAnimation()
    } else {
      self.activityIndicatorView.stopAnimation()
    }
  }
  
  func updateData()
  {
    AccountService.accountStatus { available in
      if available == true
      {
        self.shouldAnimatedIndicator(true)
        
        // Create the initial query
        let predicate = NSPredicate(value: true)
        
        let query = CKQuery(recordType: "Places", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        self.queryOperation = CKQueryOperation(query: query)
        self.queryOperation.desiredKeys = ["recordID", "name", "address", "comment", "rating", "location"]
        self.queryOperation.queuePriority = .VeryHigh
        self.queryOperation.qualityOfService = .UserInteractive
        self.queryOperation.resultsLimit = 50
        
        self.queryOperation.recordFetchedBlock = { record in
          let place = Place(record: record)
          self.places.append(place)
          
          dispatch_async(dispatch_get_main_queue(),
          {
            self.placePins()
          })
          
        }
        
        self.queryOperation.queryCompletionBlock = { (cursor:CKQueryCursor?, error: NSError?) -> Void in
          
          if (error != nil)
          {
            self.presentMessage("Error", message: "Results were not able to be retrieved. Please check your internet and iCloud settings and try again.")
            self.shouldAnimatedIndicator(false)
            return
          }
          else {
            self.searchCompleted = true
          }
        }
        
        CKContainer.defaultContainer().publicCloudDatabase.addOperation(self.queryOperation)
        
        self.delay(self.timeDelay)
        {
          if self.searchCompleted != true
          {
            self.queryOperation.cancel()
            self.shouldAnimatedIndicator(false)
            self.presentMessage("Poor network connection", message: "Results were not able to be retrieved with current network settings. Please check your internet and iCloud settings and try again.")
          }
            
          else {
            self.shouldAnimatedIndicator(false)
            self.placePins()
          }
        }
      }
      else {
        self.presentMessage("You're not logged in", message: "Please go to iCloud settings and log in with your credentials.")
      }
    }
  }
  
  func refreshAction()
  {
    self.places.removeAll()
    self.mapView.removeAnnotations(mapView.annotations)
    self.updateData()
  }
  
  func placePins()
  {
    for place: Place in self.places
    {
      if (place.location == nil) {
        continue
      }
      
      let location = CLLocationCoordinate2DMake(place.coordinate.latitude, place.coordinate.longitude)
      let dropPin = CustomPointAnnotation(place: place)
      dropPin.pinCustomImageName = "customPin"
      dropPin.coordinate = location
      dropPin.title = place.title
      dropPin.subtitle = place.subtitle
      dropPin.name = place.name

      mapView.addAnnotation(dropPin)
    }
  }
  
  // MARK: MKMapViewDelegate
  
  func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?
  {
    if !(annotation is CustomPointAnnotation)
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
    let cpa = annotation as! CustomPointAnnotation
    
    if cpa.image != nil
    {
      UIGraphicsBeginImageContext(CGSize(width: 50, height: 50))
      cpa.image!.drawInRect(CGRectMake(0, 0, 50, 50))
      let smallImage = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      let imView = UIImageView(image: smallImage)
      pinView?.leftCalloutAccessoryView = imView
      let detailButton: UIButton = UIButton(type: .DetailDisclosure)
      detailButton.setImage(UIImage(named: "mapDetailButton")?.imageWithRenderingMode(.AlwaysOriginal), forState: UIControlState.Normal)
      pinView?.rightCalloutAccessoryView = detailButton
    }

    pinView?.agCKImageAsset(cpa.recordID!, assetKey: "photo")
    pinView!.image = UIImage(named: cpa.pinCustomImageName)
   
    return pinView
  }
  
  // Animation
  func mapView(mapView: MKMapView, didAddAnnotationViews views: [MKAnnotationView])
  {
    for pins in views
    {
      let endFrame = pins.frame
      pins.frame = CGRectOffset(endFrame, 0, -500)
    
      UIView.animateWithDuration(0.5, animations: {() in
        
        pins.frame = endFrame
        }, completion: {(bool) in
          UIView.animateWithDuration(0.05, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations:{() in
            
            pins.transform = CGAffineTransformMakeScale(1.0, 0.6)
            
            }, completion: {(Bool) in
              UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations:{() in
            
                pins.transform = CGAffineTransformIdentity
                }, completion: nil)
          })
        }
      )
    }
  }

  func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)
  {
    if control == view.rightCalloutAccessoryView
    {
      self.annotation = mapView.selectedAnnotations.first as? CustomPointAnnotation

      let name = (self.annotation?.name)! as String
      let predicate = NSPredicate(format: "name = %@", name)
      let results = (self.places as NSArray).filteredArrayUsingPredicate(predicate)
      self.currentPlace = results[0] as? Place
      
      mapView.deselectAnnotation(view.annotation, animated: false)
      performSegueWithIdentifier(Constants.SegueIdentifier, sender: view)
    }
  }
  
  // MARK: Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
  {
    if segue.identifier == Constants.SegueIdentifier
    {
      if let detailedViewController = segue.destinationViewController as? DetailedViewController
      {
        detailedViewController.place = currentPlace
        detailedViewController.recordID = currentPlace?.record.recordID
      }
    }
  }
  
}