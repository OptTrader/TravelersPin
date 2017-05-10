//
//  PlaceItem.swift
//  TravelersPin
//
//  Created by Chris Kong on 11/20/15.
//  Copyright © 2015 Chris Kong. All rights reserved.
//

import UIKit
import RealmSwift
import MapKit

class PlaceItem: Object
{
  // MARK: Properties

  dynamic var name: String = ""
  dynamic var address: String = ""
  dynamic var comment: String? = nil
  dynamic var photo: NSData? = nil
  dynamic var rating: Int = 0
  dynamic var latitude: Float = 0
  dynamic var longitude: Float = 0
  
  // MARK: Map Annotation

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