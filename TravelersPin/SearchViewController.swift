//
//  SearchViewController.swift
//  TravelersPin
//
//  Created by Chris Kong on 12/23/15.
//  Copyright © 2015 Chris Kong. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

private let kShowDetailedSegueId = "showSearchDetailedSegue"

class SearchViewController: BaseViewController, UISearchBarDelegate, UISearchResultsUpdating, UITableViewDelegate, UITableViewDataSource
{
  // MARK: Properties
  
  @IBOutlet weak var tableView: UITableView!
  
  var searchCompleted = false
  var queryOperation = CKQueryOperation()
  let timeDelay = 15.0
  
  let searchController = UISearchController(searchResultsController: nil)
  private var places = [Place]()
  private var searchResults = [Place]()
  var activityIndicatorView: NVActivityIndicatorView!
  
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
    
    // Adding a search bar
    searchController.searchResultsUpdater = self
    searchController.searchBar.delegate = self
    searchController.searchBar.sizeToFit()
    searchController.searchBar.autocapitalizationType = .None
    searchController.searchBar.autocorrectionType = .Yes
    searchController.searchBar.spellCheckingType = .Yes
    searchController.searchBar.returnKeyType = .Done
    tableView.tableHeaderView = searchController.searchBar
    
    // Customize the appearance of the search bar
    searchController.dimsBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Search places..."
    searchController.searchBar.tintColor = UIColor.lightGrayColor()
    searchController.searchBar.barTintColor = UIColor.blackColor()
    definesPresentationContext = true

    // Customize table view appearance
    tableView.backgroundColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.2)
    tableView.tableFooterView = UIView(frame: CGRectZero)
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
            self.tableView.reloadData()
          }
        }
      }
      else {
        self.presentMessage("You're not logged in", message: "Please go to iCloud settings and log in with your credentials.")
      }
    }
  }
  
  // MARK: UISearchBarDelegate
  
  func searchBarSearchButtonClicked(searchBar: UISearchBar)
  {
    searchController.active = false
    searchBar.resignFirstResponder()
  }
  
  func searchBarResultsListButtonClicked(searchBar: UISearchBar)
  {

  }
  
  // MARK: UISearchResultsUpdating
  
  func updateSearchResultsForSearchController(searchController: UISearchController)
  {
    let searchString = searchController.searchBar.text ?? ""
    
    guard !searchString.isEmpty else {
      self.searchResults = []
      return
    }
    
    let predicate = NSPredicate(format: "self contains %@", searchString)
    let query = CKQuery(recordType: "Places", predicate: predicate)
    let database = CKContainer.defaultContainer().publicCloudDatabase
    
    database.performQuery(query, inZoneWithID: nil) { records, error in
      
      // Hand over the filtered results to search results table
      guard let records = records else {
        return
      }
      
      self.searchResults = records.map
      { Place(record: $0) }
      
      dispatch_async(dispatch_get_main_queue())
      {
        self.tableView.reloadData()
      }
    }
  }
  
  // MARK: UITableViewDataSource
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int
  {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    if searchController.active && searchController.searchBar.text != ""
    {
      return searchResults.count
    }
    return places.count
    
    // return searchResults.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
  {
    // Table view cells are reused and should be dequeued using a cell identifier
    let cellIdentifier = "SearchTableViewCell"
    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! SearchTableViewCell
    
    // Fetches the appropriate place for the data source layout
    let place: Place
    
    if searchController.active && searchController.searchBar.text != ""
    {
      place = searchResults[indexPath.row]
    } else {
      place = places[indexPath.row]
    }
    
    cell.nameLabel.text = place.name
    cell.addressLabel.text = place.address
    cell.photo.agCKImageAsset(place.record.recordID, assetKey: "photo")
    
    cell.backgroundColor = UIColor.clearColor()
    cell.selectionStyle = UITableViewCellSelectionStyle.None
    cell.rippleLocation = .Center
    cell.rippleLayerColor = UIColor.MKColor.DeepOrange
    
    return cell
  }
  
  // MARK: Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
  {
    if segue.identifier == kShowDetailedSegueId
    {
      if let indexPath = tableView.indexPathForSelectedRow
      {
        let place: Place
        if searchController.active && searchController.searchBar.text != ""
        {
          place = searchResults[indexPath.row]
        }
        else {
          place = places[indexPath.row]
        }
        
        let controller = segue.destinationViewController as! DetailedViewController
        controller.place = place
        controller.recordID = place.record.recordID
        controller.navigationItem.leftItemsSupplementBackButton = true
      }
    }
  }

}