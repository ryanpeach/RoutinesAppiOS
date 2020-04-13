//
//  Data.swift
//  Routines
//
//  Created by PEACH,RYAN on 4/12/20.
//  Copyright © 2020 Peach. All rights reserved.
//

enum DayOfWeek {
    case Monday
    case Tuesday
    case Wednesday
    case Thursday
    case Friday
    case Satuday
    case Sunday
}

struct Time: Hashable {
    var hour: Int
    var minute: Int
    
    func string() -> String {
        String(format: "%02d", self.hour)+":"+String(format: "%02d", self.minute)
    }
}

struct TaskData: Hashable, Identifiable {
    var id: Int
    var name: String
    var duration: Time?
    var subtasks: Array<SubTaskData>?
}

struct SubTaskData: Hashable, Identifiable {
    var id: Int
    var name: String
}

struct AlarmData: Hashable, Identifiable {
    var id: Int
    var name: String
    var time: Time
    var daysOfWeek: Set<DayOfWeek>
    var taskList: [TaskData]
    
    func getDuration() -> Time {
        Time(hour: 0, minute: 0)
    }
}

let alarmData = [
    AlarmData (
        id: 0,
        name: "Morning",
        time: Time(
            hour: 7,
            minute: 30
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
                id: 0,
                name: "Wake Up",
                duration: Optional.none,
                subtasks: Optional.none
            )
        ]
    )
]

