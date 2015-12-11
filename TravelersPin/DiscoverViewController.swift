//
//  DiscoverViewController.swift
//  TravelersPin
//
//  Created by Chris Kong on 11/28/15.
//  Copyright © 2015 Chris Kong. All rights reserved.
//

import UIKit
import CloudKit
import MobileCoreServices

class DiscoverViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate //, ModelDelegate
{
  // MARK: Properties

  @IBOutlet weak var backgroundImageView: UIImageView!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet var spinner: UIActivityIndicatorView!

  var places: [CKRecord] = []
  var imageCache: NSCache = NSCache()
  //let refreshControl = UIRefreshControl()
  
  // let model: Model = Model.sharedInstance()
  
  // MARK: View Controller Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // UI Appearance
    updateUI()

    // CloudKit
    getRecordsFromCloud()
    
//    model.delegate = self
//    model.fetchFromCloud()
    
    // Pull To Refresh Control
//    self.refreshControl.backgroundColor = UIColor.whiteColor()
//    self.refreshControl.tintColor = UIColor.orangeColor()
//    self.refreshControl.addTarget(self, action: "getRecordsFromCloud", forControlEvents: .ValueChanged)
//    collectionView?.addSubview(refreshControl)
  }
  
  func updateUI()
  {
    // Apply blurring effect
    backgroundImageView.image = UIImage(named: "backgroundImage")
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
    
    // Spinner
    spinner.hidesWhenStopped = true
    spinner.center = view.center
    spinner.color = UIColor.whiteColor()
    view.addSubview(spinner)
    spinner.startAnimating()
  }
  
  //  override func preferredStatusBarStyle() -> UIStatusBarStyle {
  //    return UIStatusBarStyle.LightContent
  //  }
  
  // MARK: - Collection View Data Source
  
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
  {
    return 1
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
  {
    return places.count
    
//    if resultController == nil
//    {
//      return 0
//    }
//    return Model.sharedInstance().places.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
  {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("DiscoverCollectionViewCell", forIndexPath: indexPath) as! DiscoverCollectionViewCell
    
    // Configure the cell
    let place = places[indexPath.row]
    cell.nameLabel?.text = place.objectForKey("name") as? String
    cell.addressLabel?.text = place.objectForKey("address") as? String
    cell.ratingControl?.rating = (place.objectForKey("rating") as? Int)!
    cell.imageView?.image = nil
    
    // Check if the image is stored in cache
    if let imageFileURL = imageCache.objectForKey(place.recordID) as? NSURL
    {
      // Fetch image from cache
      print("Get image from cache")
      cell.imageView?.image = UIImage(data: NSData(contentsOfURL: imageFileURL)!)
    
    } else {
      
      // Fetch Image from Cloud in background
      let publicDatabase = CKContainer.defaultContainer().publicCloudDatabase
      let fetchRecordsImageOperation = CKFetchRecordsOperation(recordIDs: [place.recordID])
      fetchRecordsImageOperation.desiredKeys = ["photo"]
      fetchRecordsImageOperation.queuePriority = .VeryHigh
      
      fetchRecordsImageOperation.perRecordCompletionBlock = {(record: CKRecord?, recordID: CKRecordID?, error: NSError?) -> Void in
        if (error != nil)
        {
          self.notifyUser("Failed to get image", message: "\(error!.localizedDescription)")
          return
        }
        
        if let placeRecord = record
        {
          NSOperationQueue.mainQueue().addOperationWithBlock()
          {
            if let imageAsset = placeRecord.objectForKey("photo") as? CKAsset
            {
              cell.imageView?.image = UIImage(data: NSData(contentsOfURL: imageAsset.fileURL)!)
              
              // Add the image URL to cache
              self.imageCache.setObject(imageAsset.fileURL, forKey: place.recordID)
            }
          }
        }
      }
      publicDatabase.addOperation(fetchRecordsImageOperation)
    }
    // Apply round corner
    cell.layer.cornerRadius = 4.0
    
    return cell
  }
  
  // MARK: Model Delegate
  
  // FoodPin's Method
  func getRecordsFromCloud()
  {
    // Remove existing records before refreshing
    places.removeAll()
    collectionView.reloadData()
    
    // Fetch data using Convenience API
    let cloudContainer = CKContainer.defaultContainer()
    let publicDatabase = cloudContainer.publicCloudDatabase
    let predicate = NSPredicate(value: true)
    let query = CKQuery(recordType: "Places", predicate: predicate)
    query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
    
    // Create the query operation with the query
    let queryOperation = CKQueryOperation(query: query)
    queryOperation.desiredKeys = ["name", "address", "rating"]
    queryOperation.queuePriority = .VeryHigh
    queryOperation.resultsLimit = 50
    queryOperation.recordFetchedBlock = { (record: CKRecord!) -> Void in
      if let placeRecord = record
      {
        self.places.append(placeRecord)
      }
    }
  
    queryOperation.queryCompletionBlock = { (cursor: CKQueryCursor?, error: NSError?) -> Void in
      if (error != nil)
      {
        self.notifyUser("Failed to get data from iCloud ", message: "\(error!.localizedDescription)")
      }
      
      print("Success with fetching")
      
      //self.refreshControl.endRefreshing()
      NSOperationQueue.mainQueue().addOperationWithBlock()
      {
        self.spinner.stopAnimating()
        self.collectionView.reloadData()
      }
    }
    // Execute the query
    publicDatabase.addOperation(queryOperation)
  }
  
  @IBAction func refreshAction(sender: UIBarButtonItem)
  {
    getRecordsFromCloud()
  }
  
//  func modelUpdated()
//  {
//    collectionView.reloadData()
//  }
//  
//  func errorUpdating(error: NSError)
//  {
//    let message = error.localizedDescription
//    self.notifyUser("Error Loading", message: message)
//  }
  
  
  
  
  //  let WifiSharingType : String = "WifiPassword"
  
//  var resultController: CloudKitFetchedResultController?
//  var placeObjectList: [PlaceObject] = []
//  var currentLocation: CLLocation?
//  var locationManager: CLLocationManager?
//  let radiusSearch: Float = 100000 // meters
//  


  


  
  // MARK: - DiscoverCollectionViewDelegate Methods
  
//  func didFavoriteButtonPressed(cell: DiscoverCollectionViewCell)
//  {
//    if let indexPath = collectionView.indexPathForCell(cell)
//    {
////      discoveries[indexPath.row].isFavorite = discoveries[indexPath.row].isFavorite ? false : true
////      cell.isFavorite = discoveries[indexPath.row].isFavorite
//    }
//  }
  
//  // MARK: CloudKit Predicate
//  
//  func getDataFromCloudWithPredicate(predicate predicate: NSPredicate)
//  {
//    resultController!.predicate = predicate
//    resultController!.fetchFromCloud()
//  }
//  
//  // MARK: Fetched Result Controller Delegate
//  
//  func cloudKitFetchedResultControllerErrorFetchingResult(error: NSError)
//  {
//    self.notifyUser("Searching Error", message: "Error while searching. Please try again.")
//  }
//  
//  func CloudKitFetchedResultControllerPlaceObjectDidFetchingResultSuccess()
//  {
//    self.collectionView.reloadData()
//  }
//  
//  func cloudKitFetchedResultControllerPlaceObjectDidFetchingSuccessButHaveNoResult()
//  {
//    self.notifyUser("Searching Success", message: "No results near you.")
//    self.collectionView.reloadData()
//  }
//  

  
  // Location Manager Delegate
//  
//  func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus)
//  {
//    switch (status)
//    {
//    case CLAuthorizationStatus.AuthorizedWhenInUse:
//      manager.startUpdatingLocation()
//      break
//    case CLAuthorizationStatus.Restricted:
//      self.notifyUser("Permission Denied", message: "You must enable location permission in setting")
//      break
//    case CLAuthorizationStatus.Denied:
//      self.notifyUser("Permission Denied", message: "You must enable location permission in setting")
//      break
//    default:
//      break
//    }
//  }
//  
//  func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
//  {
//    self.notifyUser("Error", message: "Error when try to get your location. Please try again.")
//  }
//  
//  func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
//  {
//    let location: CLLocation? = locations.last
//    manager.stopUpdatingLocation()
//    if location == nil
//    {
//      self.notifyUser("Error", message: "Error when try to get your location. Please try again.")
//    }
//    let predicate: NSPredicate = NSPredicate(format: "distanceToLocation:fromLocation:(%K,%@) < %f","Location", location!, radiusSearch)
//    getDataFromCloudWithPredicate(predicate: predicate)
//  }
  
  func notifyUser(title: String, message: String) -> Void
  {
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
    let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
    alert.addAction(cancelAction)
    self.presentViewController(alert, animated: true, completion: nil)
  }
  
  
}

//  let container = CKContainer.defaultContainer()
//  var publidDatabase: CKDatabase?
//  //??
//  var currentRecord: CKRecord?
//  var places = [UIImage]()
//  var photoURL: NSURL?
//
//  private var discoveries = [Discover(name: "Paris001", address: "Paris", comment: nil, photo: UIImage(named: "paris"), rating: 5, isFavorite: false),
//    Discover(name: "Rome001", address: "Rome", comment: nil, photo: UIImage(named: "rome"), rating: 4, isFavorite: false),
//    Discover(name: "London001", address: "London", comment: nil, photo: UIImage(named: "london"), rating: 3, isFavorite: false)
//    ]
//



//
//import UIKit
//import CoreLocation
//
//class PlaceTableViewController: UITableViewController, ModelDelegate, CLLocationManagerDelegate
//{
//  var detailsViewController: DetailsViewController? = nil
//  var locationManager: CLLocationManager!
//  
//  let model: Model = Model.sharedInstance()
//  
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    
//    //setupLocationManager()
//    model.delegate = self
//    model.refresh()
//    
//    // setup a refresh control
//    refreshControl = UIRefreshControl()
//    refreshControl?.addTarget(model, action: "refresh", forControlEvents: .ValueChanged)
//  }
//  
//  // MARK: Segues
//  
//  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
//  {
//    if segue.identifier == "showDetail"
//    {
//      let indexPath = self.tableView.indexPathForSelectedRow!
//      let object = Model.sharedInstance().items[indexPath.row]
//    }
//  }
//  
//  // MARK: Table view data source
//  
//  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//    
//    return 1
//  }
//  
//  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
//  {
//    return Model.sharedInstance().items.count
//  }
//  
//  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
//  {
//    let cell = tableView.dequeueReusableCellWithIdentifier("PlaceTableViewCell", forIndexPath: indexPath) as! PlaceTableViewCell
//    
//    let object = Model.sharedInstance().items[indexPath.row]
//    cell.nameLabel.text = object.name
//    cell.addressLabel.text = object.address
//    
//    object.loadCoverPhoto { image in
//      dispatch_async(dispatch_get_main_queue())
//        {
//          cell.photo.image = image
//      }
//    }
//    
//    return cell
//  }
//  
//  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//    
//    let object = Model.sharedInstance().items[indexPath.row]
//    self.detailsViewController!.detailItem = object
//    
//  }
//  
//  // MARK: Model Delegate
//  
//  func modelUpdated()
//  {
//    refreshControl?.endRefreshing()
//    tableView.reloadData()
//  }
//  
//  func errorUpdating(error: NSError)
//  {
//    let message = error.localizedDescription
//    self.notifyUser("Error Loading Albums", message: message)
//  }
//  
//  // MARK: Location stuff & delegate
//  
//  func setupLocationManager()
//  {
//    locationManager = CLLocationManager()
//    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
//    locationManager.distanceFilter = 100000000000.0 // 0.5km
//    locationManager.delegate = self
//    
//    CLLocationManager.authorizationStatus()
//  }
//  
//  func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus)
//  {
//    switch status
//    {
//    case .NotDetermined:
//      manager.requestWhenInUseAuthorization()
//    case .AuthorizedWhenInUse:
//      manager.startUpdatingLocation()
//    default:
//      // do nothing
//      print("Other status")
//    }
//  }
//  
//  func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
//  {
//    let loc = locations.last! as CLLocation
//    model.fetchAlbums(loc, radiusInMeters: 30000)
//  }
//  
//  // MARK: Alert
//  
//  func notifyUser(title: String, message: String) -> Void
//  {
//    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
//    let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
//    alert.addAction(cancelAction)
//    self.presentViewController(alert, animated: true, completion: nil)
//  }
//  
//  
//  
//}