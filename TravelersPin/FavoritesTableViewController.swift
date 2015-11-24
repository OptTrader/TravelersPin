//
//  FavoritesTableViewController.swift
//  TravelersPin
//
//  Created by Chris Kong on 11/21/15.
//  Copyright © 2015 Chris Kong. All rights reserved.
//

import UIKit
import RealmSwift

class FavoritesTableViewController: UITableViewController
{
  // MARK: Properties
  
  var datasource: Results<PlaceItem>!
  
  // MARK: View Controller Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
  
    // Load sample images??
    
    // Use the edit button item provided by the table view controller
    navigationItem.leftBarButtonItem = editButtonItem()
    
    reloadTheTable()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(true)
    
    reloadTheTable()
  }

  // MARK: - Table view data source

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int
  {
    return 1
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    return datasource.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
  {
    // Table view cells are reused and should be dequeued using a cell identifier
    let cellIdentifier = "FavoritesTableViewCell"
    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! FavoritesTableViewCell
    
    // Fetches the appropriate place for the data source layout
    let place = datasource[indexPath.row]
    
    cell.nameLabel.text = place.name
    cell.locationLabel.text = place.location
    cell.photoImageView.image = UIImage(data: place.photo!)
    cell.ratingControl.rating = place.rating
 
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
      let selectedPlace = datasource[indexPath.row]
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
    if segue.identifier == "ShowDetail"
    {
      let detailViewController = segue.destinationViewController as! DetailViewController

      // Get the cell that generated this segue
      if let selectedPlaceCell = sender as? FavoritesTableViewCell
      {
        let indexpath = tableView.indexPathForCell(selectedPlaceCell)!
        let selectedPlace = datasource[indexpath.row]
        detailViewController.place = selectedPlace
      }
    }
    else if segue.identifier == "AddPlace"
    {
    }
  }

  @IBAction func unwindToFavoritesTable(sender: UIStoryboardSegue)
  {
  }
  
  // MARK: Fetch data from Realm

  func reloadTheTable()
  {
    datasource = PlaceDataController.fetchAllPlaces()
    tableView?.reloadData()
  }

}