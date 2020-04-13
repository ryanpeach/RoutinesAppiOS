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
    var minutes: Int
    
    func getHours() -> Int {
        self.minutes / 60
    }
    
    func getMinutes() -> Int {
        self.minutes % 60
    }
    
    static func fromDayTime(hour: Int, minutes: Int) -> Time {
        Time(minutes: hour * 60 + minutes)
    }
    
    func string() -> String {
        String(format: "%02d", self.getHours())+":"+String(format: "%02d", self.getMinutes())
    }
}

struct TaskData: Hashable, Identifiable {
    var id: Int
    var name: String
    var duration: Time
    var subtasks: Array<SubTaskData>
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
        var out = Time(minutes: 0)
        for td in self.taskList {
            out.minutes += td.duration.minutes
        }
        return out
    }
}

let alarmData = [
    AlarmData (
        id: 0,
        name: "Morning",
        time: Time.fromDayTime(
            hour: 7,
            minutes: 30
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
                duration: Time(minutes: 0),
                subtasks: []
            ),
            TaskData(
                id: 1,
                name: "Go Running",
                duration: Time(minutes: 20),
                subtasks: [
                    SubTaskData(
                        id: 0,
                        name: "Wear Headband"
                    ),
                    SubTaskData(
                        id: 1,
                        name: "Bring Water"
                    )
                ]
            )
        ]
    )
]

