//
//  BaseViewController.swift
//  TravelersPin
//
//  Created by Chris Kong on 12/14/15.
//  Copyright © 2015 Chris Kong. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController
{
  // MARK: Public
  
  func presentMessage(title: String, message: String) -> Void
  {
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
    let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
    alert.addAction(cancelAction)
    self.presentViewController(alert, animated: true, completion: nil)
  }
  
  func delay(delay:Double, closure:()->())
  {
    dispatch_after(
      dispatch_time(
        DISPATCH_TIME_NOW,
        Int64(delay * Double(NSEC_PER_SEC))
      ),
      dispatch_get_main_queue(), closure)
  }

}