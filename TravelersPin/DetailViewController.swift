//
//  DetailViewController.swift
//  TravelersPin
//
//  Created by Chris Kong on 11/21/15.
//  Copyright © 2015 Chris Kong. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController
{
  // MARK: Properties
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var photoImageView: UIImageView!
  @IBOutlet weak var ratingControl: RatingControl!
  @IBOutlet weak var commentLabel: UILabel!
  
  var place: PlaceItem?

  // MARK: View Controller Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let place = place
    {
      navigationItem.title = place.name
      nameLabel.text = place.name
      locationLabel.text = place.location
      photoImageView.image = UIImage(data: place.photo!)
      ratingControl.rating = place.rating
      commentLabel.text = place.comment
    }
  }

}