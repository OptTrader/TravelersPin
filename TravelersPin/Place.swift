//
//  Place.swift
//  TravelersPin
//
//  Created by Chris Kong on 12/11/15.
//  Copyright © 2015 Chris Kong. All rights reserved.
//

import UIKit
import CloudKit
import MapKit

// MARK: Constants

let placeName = "name"
let placeAddress = "address"
let placeComment = "comment"
let placePhoto = "photo"
let placeRating = "rating"
let placeLocation = "location"

class Place: NSObject
{
  // MARK: Properties
  
  var name: String
  var address: String
  var comment: String?
  var photo: UIImage?
  var rating: Int
  var location: CLLocation?
  var identifier: String
  var record: CKRecord!
  
  // MARK: Initialization
  
  init(record: CKRecord)
  {
    self.record = record
    self.name = record.valueForKey(placeName) as! String
    self.address = record.valueForKey(placeAddress) as! String
    self.comment = record.valueForKey(placeComment) as? String
    self.rating = record.valueForKey(placeRating) as! Int
    self.location = record.valueForKey(placeLocation) as? CLLocation
    
    self.identifier = record.recordID.recordName
  }
  
  // MARK: Image Fetch Method
  
  func loadCoverPhoto(completion:(photo: UIImage!) -> ())
  {
    dispatch_async(
      dispatch_get_global_queue(
        DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0))
      {
        if let asset = self.record.valueForKey(placePhoto) as? CKAsset
        {
          if let url: NSURL = asset.fileURL
          {
            let imageData = NSData(contentsOfFile: url.path!)!
            self.photo = UIImage(data: imageData)
          }
        }
      completion(photo: self.photo)
    }
  }
  
  // MARK: Map Annotation
  
  var coordinate: CLLocationCoordinate2D {
    get {
      return location!.coordinate
    }
  }
  
  var title: String! {
    get {
      return name
    }
  }
  
  var subtitle: String! {
    get {
      return address
    }
  }

}