//
//  PlaceDataController.swift
//  TravelersPin
//
//  Created by Chris Kong on 11/21/15.
//  Copyright © 2015 Chris Kong. All rights reserved.
//

import UIKit
import RealmSwift

class PlaceDataController: NSObject
{
  class func savePlace(Place: PlaceItem)
  {
    do
    {
      let realm = try Realm()
      try realm.write({ () -> Void in
        realm.add(Place)
        print("Place Saved")
      })
    }
    catch
    {

    }
  }

  class func fetchAllPlaces() -> Results<PlaceItem>!
  {
    do
    {
      let realm = try Realm()
      return realm.objects(PlaceItem)
    }
    catch
    {
      return nil
    }
  }

  class func deletePlace(Place: PlaceItem)
  {
    do
    {
      let realm = try Realm()
      try realm.write({ () -> Void in
        realm.delete(Place)
        print("Place Deleted")
      })
    }
    catch
    {
      
    }
  }
}
