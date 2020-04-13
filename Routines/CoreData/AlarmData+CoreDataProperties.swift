//
//  AlarmData+CoreDataProperties.swift
//  Routines
//
//  Created by PEACH,RYAN (K-Atlanta,ex1) on 4/13/20.
//  Copyright © 2020 Peach. All rights reserved.
//
//

import Foundation
import CoreData


extension AlarmData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AlarmData> {
        return NSFetchRequest<AlarmData>(entityName: "AlarmData")
    }

    @NSManaged public var daysOfWeek_: Int16
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var time_: Double
    @NSManaged public var taskData: TaskData?

}
