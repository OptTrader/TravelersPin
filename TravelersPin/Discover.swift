//
//  Discover.swift
//  TravelersPin
//
//  Created by Chris Kong on 11/29/15.
//  Copyright © 2015 Chris Kong. All rights reserved.
//

import Foundation
import UIKit

class Discover
{
  // MARK: Properties
  
  var name: String = ""
  var address: String = ""
  var comment: String? = nil
  var photo: UIImage?
  //var photo: NSData? = nil
  var rating: Int = 0
  var isFavorite = false
  
//  init(name: String, address: String, comment: String?, photo: NSData!, rating: Int, isFavorite: Bool)
//  {
//    self.name = name
//    self.address = address
//    self.comment = comment
//    self.photo = photo
//    self.rating = rating
//    self.isFavorite = isFavorite
//  }
  
  init(name: String, address: String, comment: String?, photo: UIImage!, rating: Int, isFavorite: Bool)
  {
    self.name = name
    self.address = address
    self.comment = comment
    self.photo = photo
    self.rating = rating
    self.isFavorite = isFavorite
  }
  
}