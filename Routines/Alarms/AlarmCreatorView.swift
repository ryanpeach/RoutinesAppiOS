//
//  AlarmCreator.swift
//  Routines
//
//  Created by PEACH,RYAN (K-Atlanta,ex1) on 4/13/20.
//  Copyright © 2020 Peach. All rights reserved.
//

import SwiftUI
import CoreData

struct AlarmCreatorView: View {
    var moc: NSManagedObjectContext
    
    @Binding var createMode: Bool
    
    @State private var name: String = "New Alarm"
    @State private var time: Date = Date()
    
    // TODO: Make this selectable
    @State private var daysOfWeek: [DayOfWeek] = [
        DayOfWeek.Monday,
        DayOfWeek.Tuesday,
        DayOfWeek.Wednesday,
        DayOfWeek.Thursday,
        DayOfWeek.Friday,
        DayOfWeek.Saturday,
        DayOfWeek.Sunday
    ]
    
    var body: some View {
        VStack {
            Spacer()
            TitleTextField(text: self.$name)
            Spacer().frame(height: 30)
            TimePickerAbsolute(currentDate: $time)
            DaysOfWeekPicker(daysOfWeek: $daysOfWeek)
            Spacer().frame(height: DEFAULT_HEIGHT_SPACING)
            Button(action: {
                self.done()
            }) {
                Text("Save")
            }
            Spacer()
        }
    }
    
    func done() {
        let alarm = AlarmData(context: self.moc)
        alarm.daysOfWeek_ = daysOfWeekToInt(daysOfWeek: self.daysOfWeek)
        alarm.id = UUID()
        alarm.name = self.name
        
        // Get the amount of time in the date, but not the actual date itself.
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: self.time)
        let minute = calendar.component(.minute, from: self.time)
        alarm.time_ = TimeInterval(
            minute * 60 + hour * 60 * 60
        )
        
        // Set notifications
        LocalNotificationManager.requestPermission()
        var notificationIds: [String] = []
        for dayOfWeek in self.daysOfWeek {
            var nextDateComponent = calendar.dateComponents([.year, .month, .day], from: Date.today().next(.monday))
            nextDateComponent.hour = hour
            nextDateComponent.minute = minute
            let id = LocalNotificationManager.scheduleNotificationWeekly(
                time: RelativeTime.fromSeconds(seconds: alarm.time_),
                weekday: dayOfWeek,
                title: "Routine: \(self.name)",
                body: "Let's Begin!"
            )
            notificationIds.append(id)
        }
        alarm.notificationIds = notificationIds
        
        // Save
        do {
            try self.moc.save()
        } catch let error {
            print("Could not save. \(error)")
        }
        
        // Bring me back
        self.createMode = false
    }
}

struct AlarmCreator_Previewer: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @State var createMode = false
    var body: some View {
        AlarmCreatorView(moc: managedObjectContext, createMode: $createMode)
    }
}


struct AlarmCreator_Previews: PreviewProvider {
    static var previews: some View {
        AlarmCreator_Previewer()
    }
}

