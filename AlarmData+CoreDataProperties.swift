//
//  AlarmData+CoreDataProperties.swift
//  Routines
//
//  Created by PEACH,RYAN (K-Atlanta,ex1) on 4/19/20.
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
    @NSManaged public var done: Bool
    @NSManaged public var id: UUID
    @NSManaged public var lastEdited: Date?
    @NSManaged public var name: String
    @NSManaged public var notificationIds_: String?
    @NSManaged public var time_: Double
    @NSManaged public var taskData: NSOrderedSet?

}

// MARK: Generated accessors for taskData
extension AlarmData {

    @objc(insertObject:inTaskDataAtIndex:)
    @NSManaged public func insertIntoTaskData(_ value: TaskData, at idx: Int)

    @objc(removeObjectFromTaskDataAtIndex:)
    @NSManaged public func removeFromTaskData(at idx: Int)

    @objc(insertTaskData:atIndexes:)
    @NSManaged public func insertIntoTaskData(_ values: [TaskData], at indexes: NSIndexSet)

    @objc(removeTaskDataAtIndexes:)
    @NSManaged public func removeFromTaskData(at indexes: NSIndexSet)

    @objc(replaceObjectInTaskDataAtIndex:withObject:)
    @NSManaged public func replaceTaskData(at idx: Int, with value: TaskData)

    @objc(replaceTaskDataAtIndexes:withTaskData:)
    @NSManaged public func replaceTaskData(at indexes: NSIndexSet, with values: [TaskData])

    @objc(addTaskDataObject:)
    @NSManaged public func addToTaskData(_ value: TaskData)

    @objc(removeTaskDataObject:)
    @NSManaged public func removeFromTaskData(_ value: TaskData)

    @objc(addTaskData:)
    @NSManaged public func addToTaskData(_ values: NSOrderedSet)

    @objc(removeTaskData:)
    @NSManaged public func removeFromTaskData(_ values: NSOrderedSet)

}
