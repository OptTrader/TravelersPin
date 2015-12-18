//
//  CloudKitManager.swift
//  TravelersPin
//
//  Created by Chris Kong on 12/3/15.
//  Copyright © 2015 Chris Kong. All rights reserved.
//

import UIKit
import CloudKit

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
  
  // MARK: Retrieve existing records
  
  static func fetchAllRecords(completion: (records: [Place]?, error: NSError!) -> Void)
  {
    let predicate = NSPredicate(value: true)
    
    let query = CKQuery(recordType: recordType, predicate: predicate)
    
    publicCloudDatabase().performQuery(query, inZoneWithID: nil) { (records, error) in
      let places = records?.map { Place(record: $0) }
      
      dispatch_async(dispatch_get_main_queue())
      {
        completion(records: places, error: error)
      }
    }
  }

  // MARK: Add a new record
  
    
//  func saveRecord(entry : DiaryEntry) {
//    let entryRecord = CKRecord(recordType: "DiaryEntry")
//    entryRecord.setValue(entry.blurb!, forKey: "Blurb")
//    entryRecord.setValue(entry.mood, forKey: "Mood")
//    entryRecord.setObject(entry.entryDate, forKey: "Date")
//    if entry.location != nil {
//      entryRecord.setValue(entry.location!, forKey: "Location")
//    }
//    if entry.temperature != nil {
//      entryRecord.setValue(entry.temperature!, forKey: "Temp")
//    }
//    if entry.weather != nil {
//      entryRecord.setValue(entry.weather!, forKey: "Weather")
//    }
//    if entry.weatherIcon != nil {
//      entryRecord.setValue(entry.weatherIcon!, forKey: "WeatherIcon")
//    }
//    if entry.coordinates != nil {
//      entryRecord.setObject(entry.coordinates!, forKey: "Coordinates")
//    }
//    if entry.photoURL != nil {
//      let asset = CKAsset(fileURL: entry.photoURL!)
//      entryRecord.setObject(asset, forKey: "photo")
//    }
//    
//    privateDB.saveRecord(entryRecord, completionHandler: { (record, error) -> Void in
//      if ( error != nil )
//      {
//        print("Error saving to cloud kit \(error!.description)", terminator: "\n")
//      }
//      else
//      {
//        print("Saved to cloud kit", terminator: "\n")
//      }
//    })
//  }
  
  
//  static func createRecord(recordData: [String: String], completion: (record: CKRecord?, error: NSError!) -> Void)
//  {
//    let record = CKRecord(recordType: recordType)
//    
//    for (key, value) in recordData
//    {
//      if key == placePhoto
//      {
//        if let path = NSBundle.mainBundle().pathForResource(value, ofType: "jpg")
//        {
//          do {
//            let data = try NSData(contentsOfURL: NSURL(fileURLWithPath: path), options: .DataReadingMappedIfSafe)
//            record.setValue(data, forKey: key)
//          } catch let error {
//            print(error)
//          }
//        }
//      }
//      else {
//        record.setValue(value, forKey: key)
//      }
//    }
//    
//    publicCloudDatabase().saveRecord(record, completionHandler: { (savedRecord, error) in
//      dispatch_async(dispatch_get_main_queue())
//      {
//        completion(record: record, error: error)
//      }
//    })
//  }
  
  
  
  
}
//
//import UIKit
//import CloudKit
//
//private let recordType = "Cities"
//
//final class CloudKitManager {
//  
//  private init() {
//    ///forbide to create instance of helper class
//  }
//  
//  static func publicCloudDatabase() -> CKDatabase {
//    return CKContainer.defaultContainer().publicCloudDatabase
//  }
//  
//  //MARK: Retrieve existing records
//  static func fetchAllCities(completion: (records: [City]?, error: NSError!) -> Void) {
//    let predicate = NSPredicate(value: true)
//    
//    let query = CKQuery(recordType: recordType, predicate: predicate)
//    
//    publicCloudDatabase().performQuery(query, inZoneWithID: nil) { (records, error) in
//      let cities = records?.map { City(record: $0) }
//      
//      dispatch_async(dispatch_get_main_queue()) {
//        completion(records: cities, error: error)
//      }
//    }
//  }
//  
//  //MARK: add a new record
//  static func createRecord(recordData: [String: String], completion: (record: CKRecord?, error: NSError!) -> Void) {
//    let record = CKRecord(recordType: recordType)
//    
//    for (key, value) in recordData {
//      if key == cityPicture {
//        if let path = NSBundle.mainBundle().pathForResource(value, ofType: "jpg") {
//          do {
//            let data = try NSData(contentsOfURL: NSURL(fileURLWithPath: path), options: .DataReadingMappedIfSafe)
//            record.setValue(data, forKey: key)
//          } catch let error {
//            print(error)
//          }
//        }
//      } else {
//        record.setValue(value, forKey: key)
//      }
//    }
//    
//    publicCloudDatabase().saveRecord(record, completionHandler: { (savedRecord, error) in
//      dispatch_async(dispatch_get_main_queue()) {
//        completion(record: record, error: error)
//      }
//    })
//  }
//  
//  //MARK: updating the record by recordId
//  static func updateRecord(recordId: String, text: String, completion: (CKRecord!, NSError?) -> Void) {
//    let recordId = CKRecordID(recordName: recordId)
//    publicCloudDatabase().fetchRecordWithID(recordId, completionHandler: { (updatedRecord, error) in
//      
//      guard let record = updatedRecord else  {
//        dispatch_async(dispatch_get_main_queue()) {
//          completion(nil, error)
//        }
//        return
//      }
//      
//      record.setValue(text, forKey: cityText)
//      self.publicCloudDatabase().saveRecord(record, completionHandler: { (savedRecord, error) in
//        dispatch_async(dispatch_get_main_queue()) {
//          completion(savedRecord, error)
//        }
//      })
//      
//    })
//  }
//  
//  //MARK: remove the record
//  static func removeRecord(recordId: String, completion: (String!, NSError?) -> Void) {
//    let recordId = CKRecordID(recordName: recordId)
//    publicCloudDatabase().deleteRecordWithID(recordId, completionHandler: { (deletedRecordId, error) in
//      dispatch_async(dispatch_get_main_queue()) {
//        completion (deletedRecordId?.recordName, error)
//      }
//    })
//  }
//  
//  //MARK: check that user is logged
//  static func checkLoginStatus(handler: (islogged: Bool) -> Void) {
//    CKContainer.defaultContainer().accountStatusWithCompletionHandler{ (accountStatus, error) in
//      if let error = error {
//        print(error.localizedDescription)
//      }
//      switch accountStatus{
//      case .Available:
//        handler(islogged: true)
//      default:
//        handler(islogged: false)
//      }
//    }
//  }
//  
//}






//
//import Foundation
//import CloudKit
//
//protocol CloudKitDelegate {
//  //    func errorUpdating(error: NSError)
//  func diaryUpdated()
//}
//
//class CloudKitHelper {
//  var container : CKContainer
//  var publicDB : CKDatabase
//  let privateDB : CKDatabase
//  var delegate : CloudKitDelegate?
//
//  var diary = [DiaryEntry]()
//
//  init() {
//    container = CKContainer.defaultContainer()
//    publicDB = container.publicCloudDatabase
//    privateDB = container.privateCloudDatabase
//  }
//  
//  func saveRecord(entry : DiaryEntry) {
//    let entryRecord = CKRecord(recordType: "DiaryEntry")
//    entryRecord.setValue(entry.blurb!, forKey: "Blurb")
//    entryRecord.setValue(entry.mood, forKey: "Mood")
//    entryRecord.setObject(entry.entryDate, forKey: "Date")
//    if entry.location != nil {
//      entryRecord.setValue(entry.location!, forKey: "Location")
//    }
//    if entry.temperature != nil {
//      entryRecord.setValue(entry.temperature!, forKey: "Temp")
//    }
//    if entry.weather != nil {
//      entryRecord.setValue(entry.weather!, forKey: "Weather")
//    }
//    if entry.weatherIcon != nil {
//      entryRecord.setValue(entry.weatherIcon!, forKey: "WeatherIcon")
//    }
//    if entry.coordinates != nil {
//      entryRecord.setObject(entry.coordinates!, forKey: "Coordinates")
//    }
//    if entry.photoURL != nil {
//      let asset = CKAsset(fileURL: entry.photoURL!)
//      entryRecord.setObject(asset, forKey: "photo")
//    }
//    
//    privateDB.saveRecord(entryRecord, completionHandler: { (record, error) -> Void in
//      if ( error != nil )
//      {
//        print("Error saving to cloud kit \(error!.description)", terminator: "\n")
//      }
//      else
//      {
//        print("Saved to cloud kit", terminator: "\n")
//      }
//    })
//  }
//  
//  func getDiary() {
//    print("get diary", terminator: "\n")
//    let predicate = NSPredicate(value: true)
//    let sort = NSSortDescriptor(key: "Date", ascending: true)
//    
//    let query = CKQuery(recordType: "DiaryEntry",
//      predicate:  predicate)
//    query.sortDescriptors = [sort]
//    
//    privateDB.performQuery(query, inZoneWithID: nil) {
//      results, error in
//      if error != nil {
//        print("error getting entries from iCloud", terminator: "\n")
//        return
//      } else {
//        print("results : \(results!.count)", terminator: "\n")
//        //                var counter = 0
//        for record in results! {
//          let entry = DiaryEntry(record: record)
//          self.diary.append(entry)
//          //                    print("added entry \(counter++)")
//        }
//        dispatch_async(dispatch_get_main_queue()) {
//          self.delegate!.diaryUpdated()
//        }
//      }
//      print("done with getDiary")
//    }
//  }
//  
//}
