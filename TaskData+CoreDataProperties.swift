//
//  TaskData+CoreDataProperties.swift
//  Routines
//
//  Created by PEACH,RYAN (K-Atlanta,ex1) on 4/19/20.
//  Copyright © 2020 Peach. All rights reserved.
//
//

import Foundation
import CoreData


extension TaskData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskData> {
        return NSFetchRequest<TaskData>(entityName: "TaskData")
    }

    @NSManaged public var done: Bool
    @NSManaged public var duration_: Double
    @NSManaged public var id: UUID
    @NSManaged public var lastDuration_: Double
    @NSManaged public var lastEdited: Date?
    @NSManaged public var name: String
    @NSManaged public var notificationId: String?
    @NSManaged public var order: Int64
    @NSManaged public var alarmData: AlarmData
    @NSManaged public var subTaskData: NSOrderedSet?

}

// MARK: Generated accessors for subTaskData
extension TaskData {

    @objc(insertObject:inSubTaskDataAtIndex:)
    @NSManaged public func insertIntoSubTaskData(_ value: SubTaskData, at idx: Int)

    @objc(removeObjectFromSubTaskDataAtIndex:)
    @NSManaged public func removeFromSubTaskData(at idx: Int)

    @objc(insertSubTaskData:atIndexes:)
    @NSManaged public func insertIntoSubTaskData(_ values: [SubTaskData], at indexes: NSIndexSet)

    @objc(removeSubTaskDataAtIndexes:)
    @NSManaged public func removeFromSubTaskData(at indexes: NSIndexSet)

    @objc(replaceObjectInSubTaskDataAtIndex:withObject:)
    @NSManaged public func replaceSubTaskData(at idx: Int, with value: SubTaskData)

    @objc(replaceSubTaskDataAtIndexes:withSubTaskData:)
    @NSManaged public func replaceSubTaskData(at indexes: NSIndexSet, with values: [SubTaskData])

    @objc(addSubTaskDataObject:)
    @NSManaged public func addToSubTaskData(_ value: SubTaskData)

    @objc(removeSubTaskDataObject:)
    @NSManaged public func removeFromSubTaskData(_ value: SubTaskData)

    @objc(addSubTaskData:)
    @NSManaged public func addToSubTaskData(_ values: NSOrderedSet)

    @objc(removeSubTaskData:)
    @NSManaged public func removeFromSubTaskData(_ values: NSOrderedSet)

}
