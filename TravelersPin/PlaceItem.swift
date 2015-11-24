//
//  PlaceItem.swift
//  TravelersPin
//
//  Created by Chris Kong on 11/20/15.
//  Copyright © 2015 Chris Kong. All rights reserved.
//

import UIKit
import RealmSwift

class PlaceItem: Object
{
  // MARK: Properties

  dynamic var name: String = ""
  dynamic var location: String = ""
  dynamic var comment: String? = nil
  dynamic var photo: NSData? = nil
  dynamic var rating: Int = 0
}