//
//  CloudKitManager.swift
//  TravelersPin
//
//  Created by Chris Kong on 12/3/15.
//  Copyright © 2015 Chris Kong. All rights reserved.
//

import UIKit

class CloudKitManager: NSObject
{
//  import UIKit
//  import CloudKit
//  
//  class DiscoverTableViewController: UITableViewController {
//    
//    @IBOutlet var spinner:UIActivityIndicatorView!
//    
//    var restaurants:[CKRecord] = []
//    
//    var imageCache:NSCache = NSCache()
//    
//    override func viewDidLoad() {
//      super.viewDidLoad()
//      
//      spinner.hidesWhenStopped = true
//      spinner.center = view.center
//      view.addSubview(spinner)
//      spinner.startAnimating()
//      
//      getRecordsFromCloud()
//      
//      // Pull To Refresh Control
//      refreshControl = UIRefreshControl()
//      refreshControl?.backgroundColor = UIColor.whiteColor()
//      refreshControl?.tintColor = UIColor.grayColor()
//      refreshControl?.addTarget(self, action: "getRecordsFromCloud", forControlEvents: UIControlEvents.ValueChanged)
//    }

//    
//    func getRecordsFromCloud() {
//      // Fetch data using Convenience API
//      let cloudContainer = CKContainer.defaultContainer()
//      let publicDatabase = cloudContainer.publicCloudDatabase
//      let predicate = NSPredicate(value: true)
//      let query = CKQuery(recordType: "Restaurant", predicate: predicate)
//      query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
//      
//      // Create the query operation with the query
//      let queryOperation = CKQueryOperation(query: query)
//      queryOperation.desiredKeys = ["name", "type", "location"]
//      queryOperation.queuePriority = .VeryHigh
//      queryOperation.resultsLimit = 50
//      queryOperation.recordFetchedBlock = { (record:CKRecord!) -> Void in
//        if let restaurantRecord = record {
//          self.restaurants.append(restaurantRecord)
//        }
//      }
//      
//      queryOperation.queryCompletionBlock = { (cursor:CKQueryCursor?, error:NSError?) -> Void in
//        if (error != nil) {
//          print("Failed to get data from iCloud - \(error!.localizedDescription)")
//          return
//        }
//        
//        print("Successfully retrieve the data from iCloud")
//        self.refreshControl?.endRefreshing()
//        NSOperationQueue.mainQueue().addOperationWithBlock() {
//          self.spinner.stopAnimating()
//          self.tableView.reloadData()
//        }
//        
//      }
//      
//      // Execute the query
//      publicDatabase.addOperation(queryOperation)
//      
//    }
//    
//    
//    // MARK: - Table view data source
//    
//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//      return 1
//    }
//    
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//      return restaurants.count
//    }
//    
//    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//      let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! DiscoverTableViewCell
//      
//      // Configure the cell...
//      let restaurant = restaurants[indexPath.row]
//      cell.nameLabel.text = restaurant.objectForKey("name") as? String
//      cell.typeLabel.text = restaurant.objectForKey("type") as? String
//      cell.locationLabel.text = restaurant.objectForKey("location") as? String
//      
//      // Set default image
//      cell.bgImageView.image = nil
//      
//      // Check if the image is stored in cache
//      if let imageFileURL = imageCache.objectForKey(restaurant.recordID) as? NSURL {
//        // Fetch image from cache
//        print("Get image from cache")
//        cell.bgImageView.image = UIImage(data: NSData(contentsOfURL: imageFileURL)!)
//        
//      } else {
//        
//        // Fetch Image from Cloud in background
//        let publicDatabase = CKContainer.defaultContainer().publicCloudDatabase
//        let fetchRecordsImageOperation = CKFetchRecordsOperation(recordIDs: [restaurant.recordID])
//        fetchRecordsImageOperation.desiredKeys = ["image"]
//        fetchRecordsImageOperation.queuePriority = .VeryHigh
//        
//        fetchRecordsImageOperation.perRecordCompletionBlock = {(record:CKRecord?, recordID:CKRecordID?, error:NSError?) -> Void in
//          if (error != nil) {
//            print("Failed to get restaurant image: \(error!.localizedDescription)")
//            return
//          }
//          
//          if let restaurantRecord = record {
//            NSOperationQueue.mainQueue().addOperationWithBlock() {
//              if let imageAsset = restaurantRecord.objectForKey("image") as? CKAsset {
//                cell.bgImageView.image = UIImage(data: NSData(contentsOfURL: imageAsset.fileURL)!)
//                
//                // Add the image URL to cache
//                self.imageCache.setObject(imageAsset.fileURL, forKey: restaurant.recordID)
//              }
//            }
//          }
//        }
//        
//        publicDatabase.addOperation(fetchRecordsImageOperation)
//      }
//      
//      return cell
//    }
//    
//  }

}















//
//dynamic var name: String = ""
//dynamic var address: String = ""
//dynamic var comment: String? = nil
//dynamic var photo: NSData? = nil
//dynamic var rating: Int = 0


//import UIKit
//import CloudKit
//import CoreLocation
//
//struct WifiObject {
//  var recordID : CKRecordID
//  var record : CKRecord
//  var password : String
//  var SSID : String
//  var database : CKDatabase
//  
//  init(record : CKRecord, database : CKDatabase) {
//    self.database = database
//    self.record = record
//    self.recordID = record.recordID
//    self.password = record.objectForKey("Password") as! String
//    self.SSID = record.objectForKey("SSID") as! String
//  }
//  
//}
//
//protocol CloudKitFetchedResultControllerDelegate {
//  
//  func cloudKitFetchedResultControllerErrorFetchingResult(error : NSError)
//  func cloudKitFetchedResultControllerWifiObjectDidFetchingResultSuccess()
//  func cloudKitFetchedResultControllerWifiObjectDidFetchingResultSuccessButHaveNoResult()
//}
//
//class CloudKitFetchedResultController: NSObject {
//  
//  var publicDB : CKDatabase?
//  var privateDB : CKDatabase?
//  var predicate: NSPredicate! //2
//  var delegate: CloudKitFetchedResultControllerDelegate? //3
//  var results = [WifiObject]() //4
//  
//  var resultLimit = 30
//  var cursor: CKQueryCursor!
//  var startedGettingResults = false
//  let RecordType = "WifiPassword"
//  var inProgress = false
//  
//  
//  init(delegate : CloudKitFetchedResultControllerDelegate) {
//    self.delegate = delegate
//    let container : CKContainer = CKContainer.defaultContainer()
//    publicDB = container.publicCloudDatabase // Public Data
//    privateDB = container.privateCloudDatabase // Private Data
//  }
//  //MARK:
//  //MARK:  Fetch result
//  
//  func fetchFromCloud(publicDatabase yesOrNo : Bool) {
//    var database : CKDatabase!
//    if yesOrNo == true {
//      database = publicDB!
//    } else {
//      database = privateDB!
//    }
//    let query : CKQuery = CKQuery(recordType: RecordType, predicate: predicate)
//    database.performQuery(query, inZoneWithID: nil) { (results : [CKRecord]?, error : NSError?) -> Void in
//      if error != nil {
//        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//          print("Error = \(error?.description)")
//          self.delegate?.cloudKitFetchedResultControllerErrorFetchingResult(error!)
//        })
//        
//      } else {
//        if results == nil || results?.count == 0 {
//          self.results.removeAll()
//          dispatch_async(dispatch_get_main_queue(), { () -> Void in
//            self.delegate?.cloudKitFetchedResultControllerWifiObjectDidFetchingResultSuccessButHaveNoResult()
//          })
//          
//        } else {
//          self.results.removeAll()
//          for item : CKRecord in results! {
//            let wifiObject : WifiObject = WifiObject(record: item, database: database)
//            self.results.append(wifiObject)
//          }
//          dispatch_async(dispatch_get_main_queue(), { () -> Void in
//            self.delegate?.cloudKitFetchedResultControllerWifiObjectDidFetchingResultSuccess()
//          })
//          
//        }
//      }
//    }
//  }
//}
