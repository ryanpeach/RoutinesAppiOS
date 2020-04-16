//
//  SubTaskData+CoreDataProperties.swift
//  Routines
//
//  Created by PEACH,RYAN (K-Atlanta,ex1) on 4/15/20.
//  Copyright © 2020 Peach. All rights reserved.
//
//

import Foundation
import CoreData


extension SubTaskData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SubTaskData> {
        return NSFetchRequest<SubTaskData>(entityName: "SubTaskData")
    }

    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var order: Int16
    @NSManaged public var done: Bool
    @NSManaged public var lastEdited: Date?
    @NSManaged public var taskData: TaskData

}
