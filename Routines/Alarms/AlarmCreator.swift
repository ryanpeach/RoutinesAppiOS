//
//  AlarmCreator.swift
//  Routines
//
//  Created by PEACH,RYAN (K-Atlanta,ex1) on 4/13/20.
//  Copyright © 2020 Peach. All rights reserved.
//

import SwiftUI

struct AlarmCreator: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        entity: AlarmData.entity(),
        sortDescriptors: [
            NSSortDescriptor(
                keyPath: \AlarmData.time_,
                ascending: true
            )
    ]) var alarmDataList: FetchedResults<AlarmData>
    
    @State private var name: String = ""
    @State private var time: Date = Date()
    
    // TODO: Make this selectable
    @State private var daysOfWeek: [DayOfWeek] = [
        DayOfWeek.Monday,
        DayOfWeek.Tuesday,
        DayOfWeek.Wednesday,
        DayOfWeek.Thursday,
        DayOfWeek.Friday
    ]
    
    var body: some View {
        VStack {
            Spacer()
            TextField("Edit Name", text: self.$name).frame(width: 100)
            Spacer().frame(height: 30)
            TimePickerAbsolute(currentDate: $time)
            Button(action: {
                let alarm = AlarmData(context: self.managedObjectContext)
                alarm.daysOfWeek_ = daysOfWeekToInt(daysOfWeek: self.daysOfWeek)
                alarm.id = UUID()
                alarm.name = self.name
                
                // Get the amount of time in the date, but not the actual date itself.
                let calendar = Calendar.current
                let hour = calendar.component(.hour, from: self.time)
                let minutes = calendar.component(.minute, from: self.time)
                alarm.time_ = TimeInterval(
                    minutes * 60 + hour * 60 * 60
                )
            }) {
                Text("Save")
            }
            Spacer()
        }
    }
}
