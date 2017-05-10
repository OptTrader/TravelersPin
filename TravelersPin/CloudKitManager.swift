//
//  CloudKitManager.swift
//  TravelersPin
//
//  Created by Chris Kong on 12/3/15.
//  Copyright © 2015 Chris Kong. All rights reserved.
//

import UIKit
import CloudKit
import CoreLocation

// MARK: Constants

private let recordType = "Places"

final class CloudKitManager
{
  private init()
  {
    //forbide to create instance of helper class
  }
  
  static func publicCloudDatabase() -> CKDatabase
  {
    return CKContainer.defaultContainer().publicCloudDatabase
  }
  
  // MARK: Retrieve existing records with queries
  
  static func fetchAllRecords(completion: (records: [Place]?, error: NSError!) -> Void)
  {
    let predicate = NSPredicate(value: true)
    
    let query = CKQuery(recordType: recordType, predicate: predicate)
    query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
    
    publicCloudDatabase().performQuery(query, inZoneWithID: nil) { (records, error) in
      let places = records?.map { Place(record: $0) }
      
      dispatch_async(dispatch_get_main_queue())
      {
        completion(records: places, error: error)
      }
    }
  }
  
  // MARK: Retrieve records with CKQueryOperation
  
  static func fetchRecentRecords(number: Int, perRecordCompletion: Place -> Void, completion: (places: [Place], success: Bool) -> Void)
  {
    var places = [Place]()
    
    // Create the initial query
    let predicate = NSPredicate(value: true)
    
    let query = CKQuery(recordType: recordType, predicate: predicate)
    query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
    
    // Create the query operation with the query
    let queryOperation = CKQueryOperation(query: query)
    queryOperation.queuePriority = .VeryHigh
    queryOperation.qualityOfService = .UserInitiated
    queryOperation.desiredKeys = ["recordID", "name", "address", "comment", "rating", "location"]
    queryOperation.resultsLimit = number
    
    queryOperation.recordFetchedBlock = { record in
     
      let place = Place(record: record)
      places.append(place)
      
      dispatch_async(dispatch_get_main_queue(),
      {
        perRecordCompletion(place)
      })
    }
    
    queryOperation.queryCompletionBlock = { (cursor: CKQueryCursor?, error: NSError?) -> Void in
      
      if (error != nil)
      {
        print("Error: \(error!.localizedDescription)")
        return
      }
    
      dispatch_async(dispatch_get_main_queue(),
      {
        completion(places: places, success: error == nil)
      })
    }
    publicCloudDatabase().addOperation(queryOperation)
  }
  
}