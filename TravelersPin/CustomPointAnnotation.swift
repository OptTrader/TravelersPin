//
//  CustomPointAnnotation.swift
//  TravelersPin
//
//  Created by Chris Kong on 12/22/15.
//  Copyright © 2015 Chris Kong. All rights reserved.
//

import UIKit
import MapKit
import CloudKit

class CustomPointAnnotation: MKPointAnnotation
{
  // MARK: Properties
  
  var pinCustomImageName: String!
  var name: String?
  var image: UIImage?
  
  var recordID: CKRecordID?
  
  // MARK: Initialization
  
  init(place: Place)
  {
    self.name = place.name
    self.image = place.photo
    self.recordID = place.record.recordID
  }
  
}