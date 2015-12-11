//
//  Place.swift
//  TravelersPin
//
//  Created by Chris Kong on 12/10/15.
//  Copyright © 2015 Chris Kong. All rights reserved.
//

import UIKit
import CloudKit
import MapKit

class Place: NSObject
{
  var record: CKRecord!
  weak var database: CKDatabase!
  
  var name: String!
  var address: String!
  var comment: String?
  var photo: NSData?
  var rating: Int!
  var location: CLLocation?
  
  var assetCount = 0
  
  init(record: CKRecord, database: CKDatabase)
  {
    self.record = record
    self.database = database
    
    // check
    self.name = record.objectForKey("name") as! String
    self.address = record.objectForKey("address") as! String
    self.comment = record.objectForKey("comment") as? String
    // self.photo = record.objectForKey("photo") as? CKAsset
    self.rating  = record.objectForKey("rating") as? Int
    self.location = record.objectForKey("location") as? CLLocation
  }
  
  func fetchPhotos(completion: (assets: [CKRecord]!) -> ())
  {
    
  }
  
  func loadCoverPhoto(completion: (photo: UIImage!) -> ())
  {
    
  }
  
  
}