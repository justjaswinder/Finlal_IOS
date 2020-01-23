//
//  MyData+CoreDataClass.swift
//  MapPin
//
//  Created by MacStudent on 2020-01-20.
//  Copyright © 2020 MacStudent. All rights reserved.
//
//

import Foundation
import CoreData
import MapKit
@objc(MyData)
public class MyData: NSManagedObject,MKAnnotation {
    public var coordinate: CLLocationCoordinate2D {
      return CLLocationCoordinate2DMake(latitude, longitude)
    }
    public var title: String? {
      if name!.isEmpty {
        return "(No Description)"
      } else {
        return name!
      }
    }
    
    public var subtitle: String? {
      return country!
    }
    
    var hasPhoto: Bool {
           return userImage != nil
         }
         
         var photoURL: URL {
           assert(userImage != nil, "No photo ID set")
            let filename = "Photo-\(userImage!.intValue).jpg"
           return applicationDocumentsDirectory.appendingPathComponent(filename)
         }
         
         var photoImage: UIImage? {
           return UIImage(contentsOfFile: photoURL.path)
         }
         
         class func nextPhotoID() -> Int {
           let userDefaults = UserDefaults.standard
           let currentID = userDefaults.integer(forKey: "PhotoID") + 1
           userDefaults.set(currentID, forKey: "PhotoID")
           userDefaults.synchronize()
           return currentID
         }
         
    
         func removePhotoFile() {
           if hasPhoto {
             do {
               try FileManager.default.removeItem(at: photoURL)
             } catch {
               print("Error removing file: \(error)")
             }
           }
         }
       }
