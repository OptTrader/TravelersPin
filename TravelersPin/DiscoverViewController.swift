//
//  DiscoverViewController.swift
//  TravelersPin
//
//  Created by Chris Kong on 11/28/15.
//  Copyright © 2015 Chris Kong. All rights reserved.
//

import UIKit
import CloudKit

private let kShowDetailedSegueId = "showDiscoverDetailedSegue"

class DiscoverViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
  // MARK: Properties

  @IBOutlet weak var backgroundImageView: UIImageView!
  @IBOutlet weak var collectionView: UICollectionView!
  
  var searchCompleted = false
  var queryOperation = CKQueryOperation()
  let timeDelay = 15.0
  
  var places = [Place]()
  var activityIndicatorView: NVActivityIndicatorView!
  let picker = UIImagePickerController()

  // MARK: View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // View Appearance
    setupView()
    
    // Load contents
    updateData()
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    let defaults = NSUserDefaults.standardUserDefaults()
    let hasViewedWalkthrough = defaults.boolForKey("hasViewedWalkthrough")
    
    if hasViewedWalkthrough
    {
      return
    }
    
    if let pageViewController = storyboard?.instantiateViewControllerWithIdentifier("WalkthroughController") as? WalkthroughPageViewController
    {
      presentViewController(pageViewController, animated: true, completion: nil)
    }
  }
  
  // MARK: Configuration
  
  private func setupView()
  {
    // Change navigation bar's appearance
    let nav = self.navigationController?.navigationBar
    nav?.translucent = true
    nav?.shadowImage = UIImage()
    nav?.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
    if let barFont = UIFont(name: "Avenir-Light", size: 20.0)
    {
      nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: barFont]
    }
    nav?.tintColor = UIColor.whiteColor()
    
    // Background's apprearance and blurring effect
    backgroundImageView.image = UIImage(named: "dusk")
    let blurEffect = UIBlurEffect(style: .Dark)
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.frame = view.bounds
    backgroundImageView.addSubview(blurEffectView)
    
    // collectionView's UI
    collectionView.backgroundColor = UIColor.clearColor()
    
    // 4S UI Adjustment
    if UIScreen.mainScreen().bounds.size.height == 480.0
    {
      let flowLayout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
      flowLayout.itemSize = CGSizeMake(250.0, 300.0)
    }
    
    // Custom activity indicator
    let frame = CGRect(x: 0, y: 0, width: 30, height: 30)
    self.activityIndicatorView = NVActivityIndicatorView(frame: frame, type: .BallClipRotatePulse, color: UIColor.orangeColor(), padding: 30)
    self.activityIndicatorView.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2 - 150)
    self.view.addSubview(activityIndicatorView)
    
    // Refresh
    let refreshButton = MKButton()
    refreshButton.setImage(UIImage(named: "refresh"), forState: .Normal)
    refreshButton.frame = CGRectMake(0, 0, 25, 25)
    refreshButton.addTarget(self, action: #selector(DiscoverViewController.refreshAction), forControlEvents: .TouchUpInside)
    refreshButton.maskEnabled = false
    refreshButton.ripplePercent = 1.75
    refreshButton.rippleLayerColor = UIColor.MKColor.Grey
    refreshButton.backgroundAniEnabled = false
    refreshButton.rippleLocation = .Center
    
    let leftBarButton = UIBarButtonItem()
    leftBarButton.customView = refreshButton
    self.navigationItem.leftBarButtonItem = leftBarButton
    
    // Add New Place
    let cameraButton = MKButton()
    cameraButton.setImage(UIImage(named: "camera"), forState: .Normal)
    cameraButton.frame = CGRectMake(0, 0, 30, 30)
    cameraButton.addTarget(self, action: #selector(DiscoverViewController.addAction), forControlEvents: .TouchUpInside)
    cameraButton.maskEnabled = false
    cameraButton.ripplePercent = 1.75
    cameraButton.rippleLayerColor = UIColor.MKColor.Grey
    cameraButton.backgroundAniEnabled = false
    cameraButton.rippleLocation = .Center
    
    let rightBarButton = UIBarButtonItem()
    rightBarButton.customView = cameraButton
    
    // spport the initial animation.
    rightBarButton.customView!.transform = CGAffineTransformMakeScale(0, 0)
    
    // animate the button to normal size
    UIView.animateWithDuration(1.0,
      delay: 0.5,
      usingSpringWithDamping: 0.5,
      initialSpringVelocity: 10,
      options: .CurveLinear,
      animations:
      {
        rightBarButton.customView!.transform = CGAffineTransformIdentity
      },
      completion: nil
    )

    self.navigationItem.rightBarButtonItem = rightBarButton
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
            self.collectionView.reloadData()
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
    self.collectionView.reloadData()
    self.updateData()
  }

  func addAction()
  {
    let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
    
    let cameraAction = UIAlertAction(title: "Take Photo", style: UIAlertActionStyle.Default)
    {
      UIAlertAction in
      self.openCamera()
    }
  
    let libraryAction = UIAlertAction(title: "Choose From Library", style: UIAlertActionStyle.Default)
    {
      UIAlertAction in
      self.openLibrary()
    }
    
    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default)
      {
      UIAlertAction in
    }
  
    alert.addAction(cameraAction)
    alert.addAction(libraryAction)
    alert.addAction(cancelAction)
    
    // Present the controller
    self.presentViewController(alert, animated: true, completion: nil)
  }

  func openCamera()
  {
    if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil
    {
      picker.delegate = self
      picker.allowsEditing = false
      picker.sourceType = UIImagePickerControllerSourceType.Camera
      picker.cameraCaptureMode = .Photo
      presentViewController(picker, animated: true, completion: nil)
    } else {
      noCamera()
    }
  }
  
  func openLibrary()
  {
    picker.delegate = self
    picker.allowsEditing = false
    picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
    self.presentViewController(picker, animated: true, completion: nil)
  }
  
  func noCamera()
  {
    self.presentMessage("No Camera", message: "Sorry, there is no camera with this device")
  }
  
  // MARK: Collection View Data Source
  
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
  {
    return 1
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
  {
    return places.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
  {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("DiscoverCollectionViewCell", forIndexPath: indexPath) as! DiscoverCollectionViewCell
    
    let place = self.places[indexPath.row]
    
    cell.nameLabel.text = place.name
    cell.addressLabel.text = place.address

    // Set default image
    cell.imageView.backgroundColor = UIColor.darkGrayColor()
    
    cell.imageView.agCKImageAsset(place.record.recordID, assetKey: "photo")
    
    // Apply round corner
    cell.layer.cornerRadius = 4.0
    
    return cell
  }
  
  // MARK: UIImagePickerControllerDelegate
  
  func imagePickerControllerDidCancel(picker: UIImagePickerController)
  {
    // Dismiss the picker if the user canceled
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
  {
    if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
    {
      let vc = storyboard!.instantiateViewControllerWithIdentifier("newPlaceViewController") as! NewPlaceViewController
      vc.image = selectedImage
      picker.dismissViewControllerAnimated(true, completion: nil)
      
      let navigationController = UINavigationController(rootViewController: vc)
      
      self.presentViewController(navigationController, animated: true, completion: nil)
    }
  }
  
  // MARK: Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
  {
    if segue.identifier == kShowDetailedSegueId
    {
      let detailedViewController = segue.destinationViewController as! DetailedViewController
      
      // Get the cell that generated this segue
      if let selectedPlaceCell = sender as? DiscoverCollectionViewCell
      {
        let indexPath = collectionView.indexPathForCell(selectedPlaceCell)!
        let selectedPlace = places[indexPath.row]
        detailedViewController.place = selectedPlace
        detailedViewController.recordID = selectedPlace.record.recordID

      }
    }
  }
  
}