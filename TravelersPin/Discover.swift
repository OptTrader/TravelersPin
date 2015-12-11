//
//  Discover.swift
//  TravelersPin
//
//  Created by Chris Kong on 11/29/15.
//  Copyright © 2015 Chris Kong. All rights reserved.
//

import Foundation
import UIKit

class Discover
{
  // MARK: Properties
  
  var name: String = ""
  var address: String = ""
  var comment: String? = nil
  var photo: UIImage?
  //var photo: NSData? = nil
  var rating: Int = 0
  var isFavorite = false
  
//  init(name: String, address: String, comment: String?, photo: NSData!, rating: Int, isFavorite: Bool)
//  {
//    self.name = name
//    self.address = address
//    self.comment = comment
//    self.photo = photo
//    self.rating = rating
//    self.isFavorite = isFavorite
//  }
  
  init(name: String, address: String, comment: String?, photo: UIImage!, rating: Int, isFavorite: Bool)
  {
    self.name = name
    self.address = address
    self.comment = comment
    self.photo = photo
    self.rating = rating
    self.isFavorite = isFavorite
  }
  
  
  // Model
//  
//  import UIKit
//  import CloudKit
//  import MapKit
//  
//  class Album: NSObject
//  {
//    var record: CKRecord!
//    var name: String!
//    var address: String!
//    var location: CLLocation!
//    weak var database: CKDatabase!
//    
//    var assetCount = 0
//    
//    init(record: CKRecord, database: CKDatabase)
//    {
//      self.record = record
//      self.database = database
//      
//      self.name = record.objectForKey("name") as! String!
//      self.address = record.objectForKey("address") as! String!
//      self.location = record.objectForKey("location") as! CLLocation!
//    }
//    
//    func fetchPhotos(completion: (assets: [CKRecord]!) -> ())
//    {
//      let predicate = NSPredicate(format: "Album == %@", record)
//      let query = CKQuery(recordType: "photo", predicate: predicate)
//      database.performQuery(query, inZoneWithID: nil) { results, error in
//        if error == nil
//        {
//          self.assetCount = (results?.count)!
//        }
//        completion(assets: results as [CKRecord]!)
//      }
//    }
//    
//    func loadCoverPhoto(completion: (photo: UIImage!) -> ())
//    {
//      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0))
//        {
//          var image: UIImage!
//          if let asset = self.record.objectForKey("photo") as? CKAsset
//          {
//            if let url: NSURL = asset.fileURL
//            {
//              let imageData = NSData(contentsOfFile: url.path!)!
//              image = UIImage(data: imageData)
//            }
//          }
//          completion(photo: image)
//      }
//    }
//    
//    
//  }
  
  
  
}


//import AddressBook
//import CoreLocation

//class TableViewController: UITableViewController{
//  @IBOutlet weak var spinner: UIActivityIndicatorView!
//  let container = CKContainer.defaultContainer()
//  var publicDatabase: CKDatabase?
//  var currentRecord: CKRecord?
//  var photoURL: NSURL?
//  var Images = [UIImage]()
//  var textInformation = [String]()
//  var locationInformation : [(Double?,Double?)] = []
//  
//  override func viewDidLoad() {
//    spinner.hidesWhenStopped = true
//    super.viewDidLoad()
//    //var newView=UIView()
//    //newView.center = self.view.center
//    //newView.alpha = 0.5
//    spinner.center = self.tableView.center
//    self.tableView.addSubview(spinner)
//    spinner.hidden = false
//    if textInformation.count == 0 {
//      spinner.startAnimating()
//    }
//    publicDatabase = container.publicCloudDatabase
//    fetchDataFromCloud()
//    
//    // Uncomment the following line to preserve selection between presentations
//    // self.clearsSelectionOnViewWillAppear = false
//    
//    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//    // self.navigationItem.rightBarButtonItem = self.editButtonItem()
//  }
//  //override  func viewDidAppear(animated: Bool) {
//  //  super.viewDidAppear(true)
//  // fetchDataFromCloud()
//  // }
//  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//    return 1
//  }
//  func notifyUser(title:String, message: String) -> Void {
//    let alert = UIAlertController(title: title,message: message,preferredStyle:UIAlertControllerStyle.Alert)
//    let cancelAction = UIAlertAction(title:"OK",style:.Cancel,handler:nil)
//    alert.addAction(cancelAction)
//    self.presentViewController(alert, animated: true, completion: nil)
//    
//  }
//  override func prepareForSegue(segue : UIStoryboardSegue,sender: AnyObject?) {
//    let reviewVC = segue.destinationViewController as reviewViewController
//    let indexPath = self.tableView.indexPathForCell(sender as UITableViewCell)!
//    println(indexPath.row)
//    let newLocation = CLLocation(latitude: self.locationInformation[indexPath.row].0!, longitude: self.locationInformation[indexPath.row].1!)
//    let image = self.Images[indexPath.row]
//    let location = self.locationInformation[indexPath.row]
//    let text = self.textInformation[indexPath.row]
//    reviewVC.prepimage = image
//    reviewVC.preptext = text
//    reviewVC.preplocation = newLocation
//    
//    reviewVC.navigationItem.title = "there"
//    
//  }
//  func saveImageToFile(image: UIImage) -> NSURL{
//    let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
//    let docsDir: AnyObject = dirPaths[0]
//    let filePath = docsDir.stringByAppendingPathComponent("currentImage.png")
//    UIImageJPEGRepresentation(image,0.5).writeToFile(filePath, atomically: true)
//    return NSURL.fileURLWithPath(filePath)!
//  }
//  func fetchDataFromCloud(){
//    var searchText: String = "good"
//    var predicate = NSPredicate(format:" TRUEPREDICATE " )
//    
//    let query = CKQuery(recordType: "pedia", predicate: predicate)
//    publicDatabase?.performQuery(query,inZoneWithID: nil , completionHandler: ({
//      results,error in
//      if (error != nil) {
//        println("error exists")
//        dispatch_async(dispatch_get_main_queue()) {
//          self.notifyUser("cloud access error", message: error.localizedDescription)
//        }
//        
//      }else {
//        
//        if results.count > 0 {
//          
//          //var record = results[0] as CKRecord
//          //self.currentRecord = record
//          self.notifyUser("match found", message: "record matching the address ")
//          dispatch_async(dispatch_get_main_queue()){
//            for record in results {
//              
//              //self.commentsField.text = record.objectForKey("comment") as String
//              var ckrecord = record as CKRecord
//              
//              //println(ckrecord.objectForKey("longitude") as String?)
//              //println(ckrecord.objectForKey("latitude") as String?)
//              //println(ckrecord.latitude)
//              var longitude: Double? = ckrecord.objectForKey("longitude") as? Double
//              var latitude: Double? = ckrecord.objectForKey("latitude") as? Double
//              
//              let  photo = ckrecord.objectForKey("photo") as CKAsset
//              var text = ckrecord.objectForKey("comment") as String
//              var mytuple :(Double?,Double?) = (latitude,longitude)
//              let image = UIImage(contentsOfFile: photo.fileURL.path!)
//              self.Images.append(image!)
//              //text += "\n"
//              self.textInformation.append(text)
//              
//              
//              self.locationInformation.append(mytuple as (Double?,Double?))
//              
//              //self.imageView.image = image
//              self.photoURL = self.saveImageToFile(image!)
//              self.spinner.hidden = true
//              self.tableView.reloadData()
//            }
//          }
//        }else {
//          println("result not exists")
//          dispatch_async(dispatch_get_main_queue()){
//            self.notifyUser("No match found", message: "No record matching the address ")
//          }
//        }
//        
//      }
//    }))
//    
//
//
//{
//  let predicate = NSPredicate(format: "address = %@", addressField.text!)
//  
//  let query = CKQuery(recordType: "Houses", predicate: predicate)
//  
//  publicDatabase?.performQuery(query, inZoneWithID: nil, completionHandler:
//    ({results, error in
//      if (error != nil)
//      {
//        dispatch_async(dispatch_get_main_queue())
//          {
//            self.notifyUser("Cloud Access Error", message: error!.localizedDescription)
//        }
//      } else {
//        
//        if results!.count > 0
//        {
//          let record = results![0]
//          self.currentRecord = record
//          
//          dispatch_async(dispatch_get_main_queue())
//            {
//              self.commentsField.text = record.objectForKey("comment") as! String
//              
//              let photo = record.objectForKey("photo") as! CKAsset
//              
//              let image = UIImage(contentsOfFile: photo.fileURL.path!)
//              self.imageView.image = image
//              self.photoURL = self.saveImageToFile(image!)
//          }
//        } else {
//          
//          dispatch_async(dispatch_get_main_queue())
//            {
//              self.notifyUser("No Match Found", message: "No record matching the address was found")
//          }
//        }
//}















//  }
//  override func tableView(TableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    println("the number of row \(textInformation.count)")
//    return Images.count
//    
//  }
//  override func tableView(TableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//    let cell = self.tableView.dequeueReusableCellWithIdentifier("PlaceInfo",forIndexPath: indexPath) as customCellTableViewCell
//    let row = indexPath.row
//    cell.mytextLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
//    cell.mytextLabel.text = self.textInformation[row]
//    cell.myimageView.image = self.Images[row]
//    
//    let newLocation = CLLocation(latitude: self.locationInformation[row].0!, longitude: self.locationInformation[row].1!)
//    
//    let geoCoder = CLGeocoder()
//    geoCoder.reverseGeocodeLocation(newLocation, completionHandler: {(
//      placemarks: [AnyObject]!,error: NSError! ) in
//      if error != nil {
//        println ("\(error.localizedDescription)")
//      }
//      if placemarks.count > 0 {
//        let placemark = placemarks[0] as CLPlacemark
//        let addressDictionary = placemark.addressDictionary
//        let address = addressDictionary[kABPersonAddressStreetKey] as NSString
//        println(address)
//        cell.mylocationLabel.text = address as String
//      }
//    })
//    
//    //cell.mylocationLabel.text = String(format:"%f",self.locationInformation[row].0!)+String(format:"%f",self.locationInformation[row].1!)
//    return cell
//    
//  }
//  
//  
//}
