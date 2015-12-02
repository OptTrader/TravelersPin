//
//  DiscoverCollectionViewCell.swift
//  TravelersPin
//
//  Created by Chris Kong on 11/29/15.
//  Copyright © 2015 Chris Kong. All rights reserved.
//

import UIKit

protocol DiscoverCollectionViewCellDelegate {
  func didFavoriteButtonPressed(cell: DiscoverCollectionViewCell)
}

class DiscoverCollectionViewCell: UICollectionViewCell
{
  // MARK: Properties
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var ratingControl: RatingControl!
  @IBOutlet weak var favoriteButton: UIButton!
  
  var delegate: DiscoverCollectionViewCellDelegate?
  
  var isFavorite: Bool = false {
    didSet {
      if isFavorite
      {
        favoriteButton.setImage(UIImage(named: "heartfull"), forState: .Normal)
      }
      else {
        favoriteButton.setImage(UIImage(named: "heart"), forState: .Normal)
      }
    }
  }
  
  @IBAction func favoriteButtonTapped(sender: AnyObject)
  {
    delegate?.didFavoriteButtonPressed(self)
  }
  
}