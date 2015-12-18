//
//  DiscoverViewController.swift
//  TravelersPin
//
//  Created by Chris Kong on 11/28/15.
//  Copyright © 2015 Chris Kong. All rights reserved.
//

import UIKit

private let kShowDetailSegueId = "showDetailSegueId"

class DiscoverViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate
{
  // MARK: Properties

  @IBOutlet weak var backgroundImageView: UIImageView!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet var spinner: UIActivityIndicatorView!
  
  private var places = [Place]()

  // MARK: View Controller's Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // View Appearance
    setupView()

    // Reload data
    updateData()
  }
  
  // MARK: Private
  
  private func setupView()
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
    
    // Refresh
    self.navigationItem.setLeftBarButtonItem(UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "refreshAction"), animated: true)
  }
  
  //  override func preferredStatusBarStyle() -> UIStatusBarStyle {
  //    return UIStatusBarStyle.LightContent
  //  }

  func refreshAction()
  {
    self.places.removeAll()
    self.collectionView.reloadData()
    self.updateData()
  }

  func updateData()
  {
    shouldAnimatedIndicator(true)
    
    CloudKitManager.fetchAllRecords { (records, error) in
      self.shouldAnimatedIndicator(false)
      
      guard let places = records else
      {
        self.presentMessage("Error", message: error.localizedDescription)
        return
      }
      
      self.places = places
      self.collectionView.reloadData()
    }
  }
  
  private func shouldAnimatedIndicator(animate: Bool)
  {
    if animate
    {
      self.spinner.startAnimating()
    } else {
      self.spinner.stopAnimating()
    }
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
    cell.setPlace(place)
    
    // Apply round corner
    cell.layer.cornerRadius = 4.0
    
    return cell
  }
  
  // MARK: Navigation
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
  {
    if segue.identifier == kShowDetailSegueId
    {
      let detailedViewController = segue.destinationViewController as! DetailedViewController
      
      // Get the cell that generated this segue
      if let selectedPlaceCell = sender as? DiscoverCollectionViewCell
      {
        let indexPath =  collectionView.indexPathForCell(selectedPlaceCell)!
        let selectedPlace = places[indexPath.row]
        detailedViewController.place = selectedPlace
      }
    }
  }
  

}




//
//import UIKit
//
//private let kShowDetailSegueId = "showDetailSegueId"
//
//class MainViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
//  
//  @IBOutlet private var tableView: UITableView!
//  @IBOutlet private var indicatorView: UIActivityIndicatorView!
//  
//  private var cities = [City]()
//  
//  // MARK: Life cycle
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    
//    setupView()
//    
//    reloadCities()
//  }
//  
//  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//    if segue.identifier == kShowDetailSegueId {
//      
//      let selectedRows: [NSIndexPath] = self.tableView.indexPathsForSelectedRows!
//      let selectedIndexPath = selectedRows.last
//      
//      let detailedVC = segue.destinationViewController as! DetailedViewController
//      detailedVC.city = self.cities[selectedIndexPath!.row]
//    }
//  }
//  
//  // MARK: Private
//  private func setupView() {
//    let cellNib = UINib(nibName: CityTableViewCell.nibName(), bundle: nil)
//    tableView.registerNib(cellNib, forCellReuseIdentifier: CityTableViewCell.reuseIdentifier())
//    tableView.tableFooterView = UIView()
//  }
//  
//  @IBAction func reloadCities() {
//    shouldAnimateIndicator(true)
//    CloudKitManager.checkLoginStatus { isLogged in
//      self.shouldAnimateIndicator(false)
//      if isLogged {
//        self.updateData()
//      } else {
//        print("account unavailable")
//      }
//    }
//  }
//  
//  private func updateData() {
//    shouldAnimateIndicator(true)
//    
//    CloudKitManager.fetchAllCities { (records, error) in
//      self.shouldAnimateIndicator(false)
//      
//      guard let cities = records else {
//        self.presentMessage(error.localizedDescription)
//        return
//      }
//      
//      guard !cities.isEmpty else {
//        self.presentMessage("Add City from the default list. Database is empty")
//        return
//      }
//      
//      self.cities = cities
//      self.tableView.reloadData()
//    }
//  }
//  
//  private func addCity(city: City) {
//    cities.insert(city, atIndex: 0)
//    tableView.reloadData()
//  }
//  
//  private func removeCity(city: City) {
//    cities = self.cities.filter { (current: City) -> Bool in
//      return current != city
//    }
//    tableView.reloadData()
//  }
//  
//  private func shouldAnimateIndicator(animate: Bool) {
//    if animate {
//      self.indicatorView.startAnimating()
//    } else {
//      self.indicatorView.stopAnimating()
//    }
//    
//    self.tableView?.userInteractionEnabled = !animate
//    self.navigationController?.navigationBar.userInteractionEnabled = !animate
//  }
//  
//  // MARK: IBActions
//  @IBAction func unwindToMainViewController(segue: UIStoryboardSegue) {
//    if let source = segue.sourceViewController as? SelectCityViewController {
//      addCity(source.selectedCity)
//    } else if let source = segue.sourceViewController as? DetailedViewController {
//      removeCity(source.city)
//    }
//    
//    self.navigationController?.popToViewController(self, animated: true)
//  }
//  
//  // MARK: UITableViewDataSource
//  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    return cities.count
//  }
//  
//  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//    
//    let cell = tableView.dequeueReusableCellWithIdentifier(CityTableViewCell.reuseIdentifier()) as! CityTableViewCell
//    
//    let city = self.cities[indexPath.row]
//    cell.setCity(city)
//    
//    return cell
//  }
//  
//  // MARK: UITableViewDelegate
//  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//    self.performSegueWithIdentifier(kShowDetailSegueId, sender: self)
//  }
//}












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


//
//
//// MARK:- prepareForSegue
//
//override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//  
//  // retrieve selected cell & fruit
//  
//  if let indexPath = getIndexPathForSelectedCell() {
//    
//    let fruit = dataSource.fruitsInGroup(indexPath.section)[indexPath.row]
//    
//    let detailViewController = segue.destinationViewController as! DetailViewController
//    detailViewController.fruit = fruit
//  }
//}
//
//// MARK:- Should Perform Segue
//
//override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
//  return !editing
//}
//
//// MARK:- Selected Cell IndexPath
//
//func getIndexPathForSelectedCell() -> NSIndexPath? {
//  
//  var indexPath:NSIndexPath?
//  
//  if collectionView.indexPathsForSelectedItems()!.count > 0 {
//    indexPath = collectionView.indexPathsForSelectedItems()![0] as? NSIndexPath
//  }
//  return indexPath
//}
//
//// MARK:- Highlight
//
//func highlightCell(indexPath : NSIndexPath, flag: Bool) {
//  
//  let cell = collectionView.cellForItemAtIndexPath(indexPath)
//  
//  if flag {
//    cell?.contentView.backgroundColor = UIColor.magentaColor()
//  } else {
//    cell?.contentView.backgroundColor = nil
//  }
//}
