//
//  AlarmData+CoreDataClass.swift
//  Routines
//
//  Created by PEACH,RYAN (K-Atlanta,ex1) on 4/13/20.
//  Copyright © 2020 Peach. All rights reserved.
//
//

import Foundation
import CoreData
import Combine


extension AlarmData {
    
    var time: RelativeTime {
        get {
            RelativeTime.fromSeconds(seconds: TimeInterval(self.time_))
        }
        set {
            self.time_ = newValue.timeInterval
        }
    }
    
    var daysOfWeek: [DayOfWeek] {
        get {
            daysOfWeekFromInt(daysOfWeek: self.daysOfWeek_)
        }
        set {
            self.daysOfWeek_ = daysOfWeekToInt(daysOfWeek: newValue)
        }
    }
    
    var duration: RelativeTime {
        var out: TimeInterval = 0.0
        for td in self.taskData ?? [] {
            out += (td as! TaskData).duration.timeInterval
        }
        return RelativeTime.fromSeconds(seconds: out)
    }
    
    var taskDataList: [TaskData] {
        var taskDataList: [TaskData] = []
        for td in self.taskData ?? [] {
            taskDataList.append((td as! TaskData))
        }
        return taskDataList.sorted(by: { $0.order < $1.order })
    }
    
    var notificationIds: [String] {
        get {
            return self.notificationIds_?.components(separatedBy: ",") ?? []
        }
        set {
            self.notificationIds_ = newValue.joined(separator: ",")
        }
    }
    
    func delete(moc: NSManagedObjectContext) {
        for td in self.taskDataList {
            td.delete(moc: moc)
            td.objectWillChange.send()
        }
        moc.delete(self)
    }
}
