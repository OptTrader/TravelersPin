//
//  CloudKitFetchedResultController.swift
//  TravelersPin
//
//  Created by Chris Kong on 12/3/15.
//  Copyright © 2015 Chris Kong. All rights reserved.
//

import UIKit
import CloudKit
import CoreLocation

struct PlaceObject
{
  //var recordID: CKRecordID
  var record: CKRecord
  var database: CKDatabase
  var name: String
  var address: String
  var comment: String?
  var photo: UIImage?
  var rating: Int
  var location: CLLocation?
  
  init(record: CKRecord, database: CKDatabase)
  {
    self.record = record
    self.database = database
    
    self.name = record.objectForKey("name") as! String!
    self.address = record.objectForKey("address") as! String!
    self.comment = record.objectForKey("comment") as! String!
    //self.photo = record.objectForKey("photo") as! CKAsset!
    self.rating = record.objectForKey("rating") as! Int!
    self.location = record.objectForKey("location") as! CLLocation!
  }
}

protocol CloudKitFetchedResultControllerDelegate
{
  func cloudKitFetchedResultControllerErrorFetchingResult(error: NSError)
  func CloudKitFetchedResultControllerPlaceObjectDidFetchingResultSuccess()
  func cloudKitFetchedResultControllerPlaceObjectDidFetchingSuccessButHaveNoResult()
}

class CloudKitFetchedResultController: NSObject
{
  var publicDatabase: CKDatabase?
  var predicate: NSPredicate!
  var delegate: CloudKitFetchedResultControllerDelegate?
  var results = [PlaceObject]()
  
  var resultLimit = 30
  var cursor: CKQueryCursor!
  var startedGettingResults = false
  let recordType = "Places"
  var inProgress = false
  
  init(delegate: CloudKitFetchedResultControllerDelegate)
  {
    self.delegate = delegate
    let container: CKContainer = CKContainer.defaultContainer()
    publicDatabase = container.publicCloudDatabase
  }
  
  // MARK: Fetch Result
  
  func fetchFromCloud()
  {
    let database: CKDatabase! = publicDatabase
    
    let query: CKQuery = CKQuery(recordType: recordType, predicate: predicate)
    database.performQuery(query, inZoneWithID: nil) { (results: [CKRecord]?, error: NSError?) -> Void in
      if error != nil
      {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
          print("Error = \(error?.description)")
          
          self.delegate?.cloudKitFetchedResultControllerErrorFetchingResult(error!)
        })
      } else {
        if results == nil || results?.count == 0
        {
          self.results.removeAll()
          dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.delegate?.cloudKitFetchedResultControllerPlaceObjectDidFetchingSuccessButHaveNoResult()
          })
        } else {
          self.results.removeAll()
          for item: CKRecord in results!
          {
            let placeObject: PlaceObject = PlaceObject(record: item, database: database)
            self.results.append(placeObject)
          }
          dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.delegate?.CloudKitFetchedResultControllerPlaceObjectDidFetchingResultSuccess()
          })
        }
      }
    }
  }
//  
//  func loadImage(completion: (image: UIImage!) -> ())
//  {
//   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0))
//    {
//      var image: UIImage!
//      let placePhoto = record.objectForKey("photo") as CKAsset!
//      if let asset = placePhoto
//      {
//        if let url = asset.fileURL
//        {
//          let imageData = NSData(contentsOfFile: url.path!)!
//          image = UIImage(data: imageData)
//        }
//      }
//      completion(image: image)
//    }
//  }
  
}
//
//
//import Foundation
//import CloudKit
//import CoreLocation
//
//let AlbumType = "Album"
//let modelSingletonGlobal = Model()
//
//protocol ModelDelegate
//{
//  func errorUpdating(error: NSError)
//  func modelUpdated()
//}
//
//class Model
//{
//  class func sharedInstance() -> Model
//  {
//    return modelSingletonGlobal
//  }
//  
//  var delegate: ModelDelegate?
//  
//  var items = [Album]()
//  let container: CKContainer
//  let publidDB: CKDatabase
//  
//  init()
//  {
//    container = CKContainer.defaultContainer()
//    publidDB = container.publicCloudDatabase
//  }
//  
//  func refresh()
//  {
//    //let predicate = NSPredicate(value: true)
//    let predicate : NSPredicate =  NSPredicate(format:"TRUEPREDICATE")
//    let query = CKQuery(recordType: "Album", predicate: predicate)
//    publidDB.performQuery(query, inZoneWithID: nil)
//      { results, error in
//        if error != nil
//        {
//          dispatch_async(dispatch_get_main_queue())
//            {
//              self.delegate?.errorUpdating(error!)
//          }
//        } else {
//          self.items.removeAll(keepCapacity: true)
//          for record in results!
//          {
//            let album = Album(record: record as CKRecord, database: self.publidDB)
//            self.items.append(album)
//          }
//          dispatch_async(dispatch_get_main_queue())
//            {
//              self.delegate?.modelUpdated()
//              print("Model Updated!")
//          }
//        }
//    }
//  }
//  
//  func fetchAlbums(location: CLLocation, radiusInMeters: CLLocationDistance)
//  {
//    let radiusInKilometers = radiusInMeters / 1000.0
//    // check
//    let locationPredicate = NSPredicate(format: "distanceToLocation:fromLocation:(%K,%@) < %f", "location", location, radiusInKilometers)
//    let query = CKQuery(recordType: AlbumType, predicate: locationPredicate)
//    publidDB.performQuery(query, inZoneWithID: nil)
//      { results, error in
//        if error != nil
//        {
//          dispatch_async(dispatch_get_main_queue())
//            {
//              self.delegate?.errorUpdating(error!)
//              return
//          }
//        } else {
//          self.items.removeAll(keepCapacity: true)
//          for record in results!
//          {
//            let album = Album(record: record as CKRecord, database: self.publidDB)
//            self.items.append(album)
//          }
//          dispatch_async(dispatch_get_main_queue())
//            {
//              self.delegate?.modelUpdated()
//              return
//          }
//        }
//    }
//  }
//  
//  func fetchAlbums(location: CLLocation, radiusInMeters: CLLocationDistance, completion: (results: [Album]!, error: NSError!) -> ())
//  {
//    let radiusInKilometers = radiusInMeters / 1000.0
//    //Apple Campus location = 37.33182, -122.03118
//    let location = CLLocation(latitude: 37.33182, longitude: -122.03118)
//    // check
//    let locationPredicate = NSPredicate(format: "distanceToLocation:fromLocation:(%K,%@) < %f", "Location", location, radiusInKilometers)
//    let query = CKQuery(recordType: AlbumType, predicate: locationPredicate)
//    publidDB.performQuery(query, inZoneWithID: nil)
//      { results, error in
//        var art = [Album]()
//        if let records = results
//        {
//          for record in records
//          {
//            let album = Album(record: record as CKRecord, database: self.publidDB)
//            art.append(album)
//          }
//        }
//        dispatch_async(dispatch_get_main_queue())
//          {
//            completion(results: art, error: error)
//        }
//    }
//    
//  }
//  
//  
//  
//  
//  
//}

