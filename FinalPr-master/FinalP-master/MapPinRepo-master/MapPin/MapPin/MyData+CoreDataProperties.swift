//
//  MyData+CoreDataProperties.swift
//  MapPin
//
//  Created by MacStudent on 2020-01-20.
//  Copyright © 2020 MacStudent. All rights reserved.
//
//

import Foundation
import CoreData


extension MyData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MyData> {
        return NSFetchRequest<MyData>(entityName: "MyData")
    }

    @NSManaged public var name: String?
    @NSManaged public var birthday: Date?
    @NSManaged public var userImage: NSNumber?
    @NSManaged public var gender: String?
    @NSManaged public var country: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double

}
