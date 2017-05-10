//
//  FavoritesCustomPointAnnotation.swift
//  TravelersPin
//
//  Created by Chris Kong on 2/5/16.
//  Copyright © 2016 Chris Kong. All rights reserved.
//

import UIKit
import MapKit

class FavoritesCustomPointAnnotation: MKPointAnnotation
{
  // MARK: Properties
  
  var pinCustomImageName: String!
  var name: String?
  var image: UIImage?
  
  // MARK: Initialization
  
  init(place: PlaceItem)
  {
    self.name = place.name
    self.image = UIImage(data: place.photo!)
  }
  
}