//
//  DiscoverCollectionViewCell.swift
//  TravelersPin
//
//  Created by Chris Kong on 11/29/15.
//  Copyright © 2015 Chris Kong. All rights reserved.
//

import UIKit

class DiscoverCollectionViewCell: UICollectionViewCell
{
  // MARK: Properties
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var ratingControl: RatingControl!
  
  func setPlace(place: Place)
  {
    nameLabel.text = place.name
    addressLabel.text = place.address
    ratingControl.rating = place.rating
//    imageView.alpha = 0.0
    imageView.image = place.photo
    
//    UIView.animateWithDuration(0.3, animations: {
//      self.imageView.alpha = 1.0
//    })
  }

}

//
//import UIKit
//
//private let kCellReuseId = "cityTableViewCellReuseId"
//private let kCityTableViewCell = "CityTableViewCell"
//
//class CityTableViewCell: UITableViewCell {
//  
//  @IBOutlet var pictureImageView: UIImageView!
//  @IBOutlet var nameLable: UILabel!
//  
//  class func reuseIdentifier() -> String {
//    return kCellReuseId
//  }
//  
//  class func nibName() -> String {
//    return kCityTableViewCell
//  }
//  
//  func setCity(city: City) {
//    nameLable.text = city.name
//    pictureImageView.alpha = 0.0
//    pictureImageView.image = city.image
//    
//    UIView.animateWithDuration(0.3, animations: {
//      self.pictureImageView.alpha = 1.0
//    })
//  }
//}
