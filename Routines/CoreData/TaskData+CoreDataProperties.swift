//
//  TaskData+CoreDataProperties.swift
//  Routines
//
//  Created by PEACH,RYAN (K-Atlanta,ex1) on 4/13/20.
//  Copyright © 2020 Peach. All rights reserved.
//
//

import Foundation
import CoreData


extension TaskData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskData> {
        return NSFetchRequest<TaskData>(entityName: "TaskData")
    }

    @NSManaged public var duration_: Double
    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var alarmData: AlarmData?
    @NSManaged public var subTaskData: SubTaskData?

}
