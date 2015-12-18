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

}

