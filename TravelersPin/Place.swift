//
//  Place.swift
//  TravelersPin
//
//  Created by Chris Kong on 12/11/15.
//  Copyright © 2015 Chris Kong. All rights reserved.
//

import UIKit
import CloudKit

let placeName = "name"
let placeAddress = "address"
let placeComment = "comment"
let placePhoto = "photo"
let placeRating = "rating"
// let placeLocation = "location"

// private let kPlacesSourcePlist = "Places"

class Place
{
  // static var places: [[String: String]]!
  
  var name: String
  var address: String
  var comment: String?
  var photo: UIImage?
  var rating: Int
  // var location: CLLocation?
  var identifer: String
  
  // MARK: Class methods
//  static func defaultContent() -> [[String: String]]
//  {
//    if places == nil
//    {
//      let path = NSBundle.mainBundle().pathForResource(kPlacesSourcePlist, ofType: "plist")
//      let plistData = NSData(contentsOfFile: path!)
//      assert(plistData != nil, "Source doesn't exist")
//      
//      do {
//        places = try NSPropertyListSerialization.propertyListWithData(plistData!, options: .MutableContainersAndLeaves, format: UnsafeMutablePointer()) as! [[String: String]]
//      }
//      catch _ {
//        print("Cannot read data from the plist")
//      }
//    }
//    return places
//  }
  
  init(record: CKRecord)
  {
    self.name = record.valueForKey(placeName) as! String
    self.address = record.valueForKey(placeAddress) as! String
    self.comment = record.valueForKey(placeComment) as? String
    
    if let photoAsset = record.valueForKey(placePhoto) as? CKAsset
    {
      self.photo = UIImage(data: NSData(contentsOfURL: photoAsset.fileURL)!)
    }
    
    self.rating = record.valueForKey(placeRating) as! Int
    // self.location = record.valueForKey(placeLocation) as? CLLocation
 
    self.identifer = record.recordID.recordName
  }

}

//
//let coverPhoto = self.record.objectForKey("CoverPhoto") as CKAsset!
//if let asset = coverPhoto {
//  if let url = asset.fileURL {
//    let imageData = NSData(contentsOfFile: url.path!)!
//    image = UIImage(data: imageData)

//func ==(lhs: Place, rhs: Place) -> Bool
//{
//  return lhs.identifer == rhs.identifer
//}



//
//import UIKit
//import CloudKit
//
//let cityName = "name"
//let cityText = "text"
//let cityPicture = "picture"
//
//private let kCitiesSourcePlist = "Cities"
//
//class City: Equatable {
//  
//  static var cities: [[String: String]]!
//  
//  var name: String
//  var text: String
//  var image: UIImage?
//  var identifier: String
//  
//  // MARK: Class methods
//  static func defaultContent() -> [[String: String]] {
//    if cities == nil {
//      let path = NSBundle.mainBundle().pathForResource(kCitiesSourcePlist, ofType: "plist")
//      let plistData = NSData(contentsOfFile: path!)
//      assert(plistData != nil, "Source doesn't exist")
//      
//      do {
//        cities = try NSPropertyListSerialization.propertyListWithData(plistData!,
//          options: .MutableContainersAndLeaves, format: UnsafeMutablePointer()) as! [[String: String]]
//      }
//      catch _ {
//        print("Cannot read data from the plist")
//      }
//    }
//    
//    return cities
//  }
//  
//  init(record: CKRecord) {
//    self.name = record.valueForKey(cityName) as! String
//    self.text = record.valueForKey(cityText) as! String
//    if let imageData = record.valueForKey(cityPicture) as? NSData {
//      self.image = UIImage(data:imageData)
//    }
//    self.identifier = record.recordID.recordName
//  }
//  
//}
//
//func ==(lhs: City, rhs: City) -> Bool {
//  return lhs.identifier == rhs.identifier
//}





















//init(record: CKRecord) {
//  self.name = record.valueForKey(cityName) as! String
//  self.text = record.valueForKey(cityText) as! String
//  if let imageData = record.valueForKey(cityPicture) as? NSData {
//    self.image = UIImage(data:imageData)
//  }
//  self.identifier = record.recordID.recordName
//}

//import Foundation
//import CoreLocation
//import CloudKit
//import UIKit
//
//class DiaryEntry {
//  var blurb : String?
//  var entryDate : NSDate
//  var mood : Double = 0
//  var location: String?
//  var coordinates : CLLocation?
//  var weather : String?
//  var temperature : String?
//  var weatherIcon : String?
//  var photoURL : NSURL?
//  var image : UIImage?
//  


//  
//  init( record: CKRecord ) {
//    blurb = record.valueForKey("Blurb") as? String
//    entryDate = record.objectForKey("Date") as! NSDate
//    mood = record.valueForKey("Mood") as! Double
//    location = record.valueForKey("Location") as? String
//    coordinates = record.objectForKey("Coordinates") as? CLLocation
//    weather = record.valueForKey("Weather") as? String
//    temperature = record.valueForKey("Temp") as? String
//    weatherIcon = record.valueForKey("WeatherIcon") as? String
//    
//    if let photo = record.objectForKey("photo") as? CKAsset {
//      image = UIImage(contentsOfFile: photo.fileURL.path!)
//    }
//    //        println("read DB entry \(self.description)")
//  }
//}