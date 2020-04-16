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


extension AlarmData {
    var time: RelativeTime {
        RelativeTime.fromSeconds(seconds: TimeInterval(self.time_))
    }
    
    var daysOfWeek: [DayOfWeek] {
        daysOfWeekFromInt(daysOfWeek: self.daysOfWeek_)
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
    
    var today: Date {
        let todayComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        return Calendar.current.date(from: todayComponents)! + self.duration.timeInterval
    }
}
