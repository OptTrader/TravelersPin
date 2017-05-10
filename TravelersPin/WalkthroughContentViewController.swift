//
//  WalkthroughContentViewController.swift
//  TravelersPin
//
//  Created by Chris Kong on 1/22/16.
//  Copyright © 2016 Chris Kong. All rights reserved.
//

import UIKit

class WalkthroughContentViewController: BaseViewController
{
  // MARK: Properties

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var contentView: UIView!
  @IBOutlet weak var contentImageView: UIImageView!
  @IBOutlet weak var discoverSpotlightView: UIView!
  @IBOutlet weak var locateSpotlightView: UIView!
  @IBOutlet weak var favoritesSpotlightView: UIView!
  @IBOutlet weak var shareSpotlightView: UIView!
  @IBOutlet weak var subtitleLabel: UILabel!
  @IBOutlet weak var forwardButton: MKButton!
  @IBOutlet weak var getStartedButton: MKButton!
  @IBOutlet weak var pageControl: UIPageControl!

  var index = 0
  var heading = ""
  var contentImageFile = ""
  var subheading = ""
  
  // MARK: View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupView()
    setupContents()
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
  
    discoverSpotlightView.transform = CGAffineTransformMakeScale(0.0, 0.0)
    shareSpotlightView.transform = CGAffineTransformMakeScale(0.0, 0.0)
    locateSpotlightView.transform = CGAffineTransformMakeScale(0.0, 0.0)
    favoritesSpotlightView.transform = CGAffineTransformMakeScale(0.0, 0.0)
  
    UIView.animateWithDuration(1.0,
      delay: 0.5,
      usingSpringWithDamping: 0.5,
      initialSpringVelocity: 5,
      options: .CurveLinear,
      animations:
      {
        self.discoverSpotlightView.transform = CGAffineTransformIdentity
        self.shareSpotlightView.transform = CGAffineTransformIdentity
        self.locateSpotlightView.transform = CGAffineTransformIdentity
        self.favoritesSpotlightView.transform = CGAffineTransformIdentity
      },
      completion: nil
    )
  }
  
  // MARK: Configuration
  
  private func setupView()
  {
    if case 0 = index
    {
      forwardButton.hidden = false
      getStartedButton.hidden = true
      discoverSpotlightView.hidden = false
  
      // Animation
      discoverSpotlightView.transform = CGAffineTransformMakeScale(0.0, 0.0)
      UIView.animateWithDuration(1.0,
        delay: 0.5,
        usingSpringWithDamping: 0.5,
        initialSpringVelocity: 5,
        options: .CurveLinear,
        animations:
        {
          self.discoverSpotlightView.transform = CGAffineTransformIdentity
        },
        completion: nil
      )
  
      shareSpotlightView.hidden = true
      locateSpotlightView.hidden = true
      favoritesSpotlightView.hidden = true
    }
  
    else if case 1 = index
    {
      forwardButton.hidden = false
      getStartedButton.hidden = true
      discoverSpotlightView.hidden = true
      shareSpotlightView.hidden = false
  
      // Animation
      shareSpotlightView.transform = CGAffineTransformMakeScale(0.0, 0.0)
  
      UIView.animateWithDuration(1.0,
        delay: 0.5,
        usingSpringWithDamping: 0.5,
        initialSpringVelocity: 5,
        options: .CurveLinear,
        animations:
        {
          self.shareSpotlightView.transform = CGAffineTransformIdentity
        },
        completion: nil
      )
  
      locateSpotlightView.hidden = true
      favoritesSpotlightView.hidden = true
    }
  
    else if case 2 = index
    {
      forwardButton.hidden = false
      getStartedButton.hidden = true
      discoverSpotlightView.hidden = true
      shareSpotlightView.hidden = true
      locateSpotlightView.hidden = false
  
      // Animation
      locateSpotlightView.transform = CGAffineTransformMakeScale(0.0, 0.0)
  
      UIView.animateWithDuration(1.0,
        delay: 0.5,
        usingSpringWithDamping: 0.5,
        initialSpringVelocity: 5,
        options: .CurveLinear,
        animations:
        {
          self.locateSpotlightView.transform = CGAffineTransformIdentity
        },
        completion: nil
      )
  
      favoritesSpotlightView.hidden = true
    }
  
    else if case 3 = index
    {
      forwardButton.hidden = true
      getStartedButton.hidden = false
      discoverSpotlightView.hidden = true
      shareSpotlightView.hidden = true
      locateSpotlightView.hidden = true
      favoritesSpotlightView.hidden = false
  
      // Animation
      favoritesSpotlightView.transform = CGAffineTransformMakeScale(0.0, 0.0)
  
      UIView.animateWithDuration(1.0,
        delay: 0.5,
        usingSpringWithDamping: 0.5,
        initialSpringVelocity: 5,
        options: .CurveLinear,
        animations:
        {
          self.favoritesSpotlightView.transform = CGAffineTransformIdentity
        },
        completion: nil
      )
    }
    
  }
  
  private func setupContents()
  {
    titleLabel.text = heading
    subtitleLabel.text = subheading
    contentImageView.image = UIImage(named: self.contentImageFile)
  
    // Set up the current page
    pageControl.currentPage = index
  }

  // MARK: Actions
  
  @IBAction func forwardAction(sender: MKButton)
  {
    switch index
    {
    case 0...3:
      let pageViewController = parentViewController as! WalkthroughPageViewController
      pageViewController.forward(index)
  
    default: break
    }
  }

  @IBAction func getStartedAction(sender: MKButton)
  {
    let defaults = NSUserDefaults.standardUserDefaults()
    defaults.setBool(true, forKey: "hasViewedWalkthrough")
    dismissViewControllerAnimated(true, completion: nil)
  }
  
}