//
//  DiscoverViewController.swift
//  TravelersPin
//
//  Created by Chris Kong on 11/28/15.
//  Copyright © 2015 Chris Kong. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, DiscoverCollectionViewCellDelegate
{
  // MARK: Properties
  
  @IBOutlet weak var backgroundImageView: UIImageView!
  @IBOutlet weak var collectionView: UICollectionView!
  
  private var discoveries = [Discover(name: "Paris001", address: "Paris", comment: nil, photo: UIImage(named: "paris"), rating: 5, isFavorite: false),
    Discover(name: "Rome001", address: "Rome", comment: nil, photo: UIImage(named: "rome"), rating: 4, isFavorite: false),
    Discover(name: "London001", address: "London", comment: nil, photo: UIImage(named: "london"), rating: 3, isFavorite: false)
    ]
  
  // MARK: View Controller Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Apply blurring effect
    backgroundImageView.image = UIImage(named: "backgroundImage")
    let blurEffect = UIBlurEffect(style: .Dark)
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.frame = view.bounds
    backgroundImageView.addSubview(blurEffectView)
  
    // collectionView's UI
    collectionView.backgroundColor = UIColor.clearColor()
    
    // 4S UI Adjustment
    if UIScreen.mainScreen().bounds.size.height == 480.0
    {
      let flowLayout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
      flowLayout.itemSize = CGSizeMake(250.0, 300.0)
    }
    
  }

  //  override func preferredStatusBarStyle() -> UIStatusBarStyle {
  //    return UIStatusBarStyle.LightContent
  //  }
  
  // MARK: - Collection View Data Source
 
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
  {
    return 1
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
  {
    return discoveries.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
  {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("DiscoverCollectionViewCell", forIndexPath: indexPath) as! DiscoverCollectionViewCell
    
    // Configure the cell
    cell.nameLabel.text = discoveries[indexPath.row].name
    cell.addressLabel.text = discoveries[indexPath.row].address
    cell.imageView.image = discoveries[indexPath.row].photo
    cell.ratingControl.rating = discoveries[indexPath.row].rating
    cell.isFavorite = discoveries[indexPath.row].isFavorite
    cell.delegate = self
    
    // Apply round corner
    cell.layer.cornerRadius = 4.0
    
    return cell
  }
  
  // MARK: - DiscoverCollectionViewDelegate Methods
  
  func didFavoriteButtonPressed(cell: DiscoverCollectionViewCell)
  {
    if let indexPath = collectionView.indexPathForCell(cell)
    {
      discoveries[indexPath.row].isFavorite = discoveries[indexPath.row].isFavorite ? false : true
      cell.isFavorite = discoveries[indexPath.row].isFavorite
    }
  }
  
}