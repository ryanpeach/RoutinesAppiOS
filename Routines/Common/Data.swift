//
//  Data.swift
//  Routines
//
//  Created by PEACH,RYAN on 4/12/20.
//  Copyright © 2020 Peach. All rights reserved.
//

import Foundation

enum DayOfWeek {
    case Monday
    case Tuesday
    case Wednesday
    case Thursday
    case Friday
    case Satuday
    case Sunday
}

struct TaskData: Hashable, Identifiable {
    var id: UUID
    var name: String
    var duration: RelativeTime
    var subtasks: Array<SubTaskData>
}

struct SubTaskData: Hashable, Identifiable {
    var id: UUID
    var name: String
}

struct AlarmData: Hashable, Identifiable {
    var id: UUID
    var name: String
    var time: RelativeTime
    var daysOfWeek: Set<DayOfWeek>
    var taskList: [TaskData]
    
    func getDuration() -> RelativeTime {
        var sec: TimeInterval = 0.0
        for td in self.taskList {
            sec += td.duration.timeInterval
        }
        return RelativeTime.fromSeconds(seconds: sec)
    }
}

var alarmDataList: Array<AlarmData> = [
    AlarmData (
        id: UUID(),
        name: "Morning",
        time: RelativeTime.fromDayTime(
            hours: 7,
            minutes: 30,
            seconds: 0.0
        ),
        daysOfWeek: Set([
            DayOfWeek.Monday,
            DayOfWeek.Tuesday,
            DayOfWeek.Wednesday,
            DayOfWeek.Thursday,
            DayOfWeek.Friday
        ]),
        taskList: [
            TaskData(
                id: UUID(),
                name: "Wake Up",
                duration: RelativeTime.fromSeconds(seconds: 0.0),
                subtasks: []
            ),
            TaskData(
                id: UUID(),
                name: "Go Running",
                duration: RelativeTime.fromSeconds(seconds: 20.0*60),
                subtasks: [
                    SubTaskData(
                        id: UUID(),
                        name: "Wear Headband"
                    ),
                    SubTaskData(
                        id: UUID(),
                        name: "Bring Water"
                    )
                ]
            )
        ]
    )
]

