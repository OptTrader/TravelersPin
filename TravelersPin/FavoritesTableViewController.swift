//
//  FavoritesTableViewController.swift
//  TravelersPin
//
//  Created by Chris Kong on 11/21/15.
//  Copyright © 2015 Chris Kong. All rights reserved.
//

import UIKit
import RealmSwift

private let kShowFavoriteDetailSegueId = "showFavoriteDetailSegue"

class FavoritesTableViewController: UITableViewController
{
  // MARK: Properties
  
  var datasource: Results<PlaceItem>?
  
  // MARK: View Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Use the edit button item provided by the table view controller
    navigationItem.leftBarButtonItem = editButtonItem()
    
    setupView()
    reloadTheTable()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(true)
    
    reloadTheTable()
    
    // Navigation Bar Appearance
    navigationBarSetupView()
  }

  // MARK: Configuration
  
  private func setupView()
  {
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
  
  // Fetch data from Realm
  func reloadTheTable()
  {
    datasource = PlaceDataController.fetchAllPlaces()
    tableView?.reloadData()
  }
  
  // MARK: UITableViewDataSource

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int
  {
    return 1
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    return datasource?.count ?? 0
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
  {
    // Table view cells are reused and should be dequeued using a cell identifier
    let cellIdentifier = "FavoritesTableViewCell"
    
    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! FavoritesTableViewCell
    
    // Fetches the appropriate place for the data source layout
    let place = datasource![indexPath.row]
    
    cell.nameLabel.text = place.name
    cell.photoImageView.image = UIImage(data: place.photo!)
    cell.ratingControl.rating = place.rating
    
    cell.backgroundColor = UIColor.clearColor()
    cell.selectionStyle = UITableViewCellSelectionStyle.None
    cell.rippleLocation = .Center
    cell.rippleLayerColor = UIColor.MKColor.DeepOrange
    
    return cell
  }
  
  // Override to support conditional editing of the table view
  override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
  {
    // Return false if you do not want the specified item to be editable
    return true
  }
  
  // Override to support editing the table view
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
  {
    if editingStyle == .Delete
    {
      // Delete the row from the data source
      let selectedPlace = datasource![indexPath.row]
      PlaceDataController.deletePlace(selectedPlace)
      tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
      reloadTheTable()
    }
    else if editingStyle == .Insert {
      // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
  }
  
  // MARK: Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
  {
    if segue.identifier == kShowFavoriteDetailSegueId
    {
      let favoriteDetailViewController = segue.destinationViewController as! FavoriteDetailViewController

      // Get the cell that generated this segue
      if let selectedPlaceCell = sender as? FavoritesTableViewCell
      {
        let indexpath = tableView.indexPathForCell(selectedPlaceCell)!
        let selectedPlace = datasource![indexpath.row]
        favoriteDetailViewController.place = selectedPlace
      }
    }
  }

  @IBAction func unwindToFavoritesTable(sender: UIStoryboardSegue)
  {
  }
  
}