//
//  AccountService.swift
//  TravelersPin
//
//  Created by Chris Kong on 3/17/16.
//  Copyright © 2016 Chris Kong. All rights reserved.
//

import Foundation
import CloudKit

class AccountService
{
  class func accountStatus(completion: (available: Bool) -> Void)
  {
    CKContainer.defaultContainer().accountStatusWithCompletionHandler { (status, error) -> Void in
//      print("account status = \(status.rawValue)")
      guard error == nil else
      {
//        print("UserService err: \(error)")
        completion(available: false)
        return
      }
      completion(available: true)
    }
  }
  
}