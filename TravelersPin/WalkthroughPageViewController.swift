//
//  WalkthroughPageViewController.swift
//  TravelersPin
//
//  Created by Chris Kong on 1/22/16.
//  Copyright © 2016 Chris Kong. All rights reserved.
//

import UIKit

class WalkthroughPageViewController: UIPageViewController, UIPageViewControllerDataSource
{
  // MARK: Properties
  
  var pageHeadings = ["Discover Places", "Share Experiences", "Locate", "Save Favorites"]
  var pageImages = ["discover-scene", "share-scene", "locate-scene", "favorites-scene"]
  var pageSubheadings = ["Discover all the interesting places to travel", "Share your amazing experiences to the world", "Locate places on the map or search by name or location", "Save your favorite places"]
  
  // MARK: View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Set the data source to itself
    dataSource = self

    // Create the first walkthrough screen
    if let startingViewController = viewControllerAtIndex(0)
    {
      setViewControllers([startingViewController], direction: .Forward, animated: true, completion: nil)
    }
  }
  
  // MARK: UIPageViewController's Data Source Methods

  func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
  {
    var index = (viewController as! WalkthroughContentViewController).index
    index += 1

    return viewControllerAtIndex(index)
  }

  func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
  {
    var index = (viewController as! WalkthroughContentViewController).index
    index -= 1

    return viewControllerAtIndex(index)
  }
  
  func viewControllerAtIndex(index: Int) -> WalkthroughContentViewController?
  {
    if index == NSNotFound || index < 0 || index >= pageHeadings.count
    {
      return nil
    }

    // Create a new view controller and pass suitable data
    if let pageContentViewController = storyboard?.instantiateViewControllerWithIdentifier("WalkthroughContentViewController") as? WalkthroughContentViewController
    {
      pageContentViewController.heading = pageHeadings[index]
      pageContentViewController.contentImageFile = pageImages[index]
      pageContentViewController.subheading = pageSubheadings[index]
      pageContentViewController.index = index

      return pageContentViewController
    }
    return nil
  }
  
  // MARK: Actions
  
  func forward(index: Int)
  {
    if let nextViewController = viewControllerAtIndex(index + 1)
    {
      setViewControllers([nextViewController], direction: .Forward, animated: true, completion: nil)
    }
  }

}