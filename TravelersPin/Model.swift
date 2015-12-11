//
//  Model.swift
//  TravelersPin
//
//  Created by Chris Kong on 12/9/15.
//  Copyright © 2015 Chris Kong. All rights reserved.
//

import Foundation
import CloudKit
import CoreLocation

let PlaceType = "Place"
let ModelSingletonGlobal = Model()

protocol ModelDelegate
{
  func errorUpdating(error: NSError)
  func modelUpdated()
}

class Model
{
  class func sharedInstance() -> Model
  {
    return ModelSingletonGlobal
  }
  
  var delegate: ModelDelegate?
  
  var places = [Place]()
  let container: CKContainer
  let publicDatabase: CKDatabase
  
  init()
  {
    container = CKContainer.defaultContainer()
    publicDatabase = container.publicCloudDatabase
  }
  
  func fetchFromCloud()
  {
    let predicate: NSPredicate = NSPredicate(value: true)
    let query = CKQuery(recordType: "Place", predicate: predicate)
    query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
    
    let queryOperation = CKQueryOperation(query: query)
    queryOperation.desiredKeys = ["name", "address"]
    queryOperation.queuePriority = .VeryHigh
    queryOperation.resultsLimit = 50
    queryOperation.recordFetchedBlock = { (record: CKRecord!) -> Void in
      let place = Place(record: record, database: self.publicDatabase)
      self.places.append(place)
    }
    
    queryOperation.queryCompletionBlock = { (cursor: CKQueryCursor?, error: NSError?) -> Void in
      if (error != nil)
      {
        dispatch_async(dispatch_get_main_queue())
        {
          self.delegate?.errorUpdating(error!)
        }
      }
      dispatch_async(dispatch_get_main_queue())
      {
        self.delegate?.modelUpdated()
        print("Model Updated!")
      }
      
      NSOperationQueue.mainQueue().addOperationWithBlock()
      {
        
      }
      
    
    }
    
    
    
    publicDatabase.performQuery(query, inZoneWithID: nil) {
      (results, error) -> Void in
      if error != nil
      {
        dispatch_async(dispatch_get_main_queue())
        {
          self.delegate?.errorUpdating(error!)
        }
      } else {
        self.places.removeAll(keepCapacity: true)
        for record in results!
        {
          let place = Place(record: record as CKRecord, database: self.publicDatabase)
          self.places.append(place)
        }
        dispatch_async(dispatch_get_main_queue())
        {
          self.delegate?.modelUpdated()
          print("Model Updated!")
        }
      }
    }
  }
  
  
  
//  func getRecordsFromCloud()
//  {
//    // Fetch data using Convenience API
//    let cloudContainer = CKContainer.defaultContainer()
//    let publicDatabase = cloudContainer.publicCloudDatabase
//    let predicate = NSPredicate(value: true)
//    let query = CKQuery(recordType: "Place", predicate: predicate)
//    // to update
//    query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
//    
//    let queryOperation = CKQueryOperation(query: query)
//    queryOperation.desiredKeys = ["name", "type", "neighborhood"]
//    queryOperation.queuePriority = .VeryHigh
//    queryOperation.resultsLimit = 50
//    queryOperation.recordFetchedBlock = { (record: CKRecord!) -> Void in
//      if let placeRecord = record
//      {
//        self.records.append(placeRecord)
//      }
//    }
//    
//    queryOperation.queryCompletionBlock = { (cursor: CKQueryCursor?, error: NSError?) -> Void in
//      if (error != nil)
//      {
//        print("Failed to get data from iCloud - \(error!.localizedDescription)")
//        return
//      }
//      
//      print("Successfully retrieve the data from iCloud")
//      self.refreshControl?.endRefreshing()
//      
//      NSOperationQueue.mainQueue().addOperationWithBlock()
//        {
//          self.spinner.stopAnimating()
//          self.tableView.reloadData()
//      }
//    }
//    // Clear array
//    records.removeAll()
//    
//    // Execute the query
//    publicDatabase.addOperation(queryOperation)
//  }

  
  
}