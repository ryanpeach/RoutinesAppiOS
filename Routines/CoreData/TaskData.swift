//
//  TaskData+CoreDataClass.swift
//  Routines
//
//  Created by PEACH,RYAN (K-Atlanta,ex1) on 4/13/20.
//  Copyright © 2020 Peach. All rights reserved.
//
//

import Foundation
import CoreData

extension TaskData {
    var lastDuration: RelativeTime {
        get {
            RelativeTime.fromSeconds(seconds: TimeInterval(self.lastDuration_))
        }
        set {
            self.lastDuration_ = newValue.timeInterval
        }
    }
    
    var duration: RelativeTime {
        get {
            RelativeTime.fromSeconds(seconds: TimeInterval(self.duration_))
        }
        set {
            self.duration_ = newValue.timeInterval
        }
    }
    
    var subTaskDataList: [SubTaskData] {
        var subTaskDataList: [SubTaskData] = []
        for sub_td in self.subTaskData ?? [] {
            subTaskDataList.append((sub_td as! SubTaskData))
        }
        return subTaskDataList.sorted(by: { $0.order < $1.order })
    }
    
    func resetDone() {
        if self.lastEdited == nil {
            self.done = false
            for subTaskData in self.subTaskDataList {
                subTaskData.resetDone()
            }
        } else {
            // This is now
            let todayComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
            
            // This is the reset time
            let hour = SettingsBundleHelper.getResetHour()
            let resetTimeToday = DateComponents(
                year: todayComponents.year,
                month: todayComponents.month,
                day: todayComponents.day,
                hour: hour,
                minute: 0,
                second: 0
            )
            
            // The main logic
            let isAfterResetTime = Date() > Calendar.current.date(from: resetTimeToday)!
            let hasBeenEdited = self.lastEdited! > Calendar.current.date(from: resetTimeToday)!
            
            if isAfterResetTime && (!hasBeenEdited) {
                self.done = false
            }
            
            for subTaskData in self.subTaskDataList {
                subTaskData.resetDone()
            }
            
            self.objectWillChange.send()
        }
    }
}

