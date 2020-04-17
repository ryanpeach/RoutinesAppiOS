//
//  AlarmCreator.swift
//  Routines
//
//  Created by PEACH,RYAN (K-Atlanta,ex1) on 4/13/20.
//  Copyright © 2020 Peach. All rights reserved.
//

import SwiftUI

struct AlarmEditor: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @Binding var inEditing: Bool
    @ObservedObject var alarmData: AlarmData
    
    var body: some View {
        VStack {
            Spacer()
            TitleTextField(text: self.$alarmData.name)
            Spacer().frame(height: 30)
            TimePickerAbsolute(currentDate: self.$alarmData.time.today)
            DaysOfWeekPicker(daysOfWeek: self.$alarmData.daysOfWeek)
            Spacer()
        }
        .navigationBarBackButtonHidden(true) // not needed, but just in case
        .navigationBarItems(leading: MyBackButton(label: "Back") {
            self.inEditing = false
            self.setNotifications()
        })
    }
    
    func setNotifications() {
        // Delete Old Notifications
        if self.alarmData.notificationIds_ != nil {
            for id in self.alarmData.notificationIds {
                // TODO: Check if this is safe if id has already executed
                LocalNotificationManager.deleteNotification(id: id)
            }
        }
        
        // Set notifications
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: self.alarmData.time.today)
        let minute = calendar.component(.minute, from: self.alarmData.time.today)
        LocalNotificationManager.requestPermission()
        var notificationIds: [String] = []
        for dayOfWeek in self.alarmData.daysOfWeek {
            var nextDateComponent = calendar.dateComponents([.year, .month, .day], from: Date.today().next(.monday))
            nextDateComponent.hour = hour
            nextDateComponent.minute = minute
            let id = LocalNotificationManager.scheduleNotificationWeekly(
                time: RelativeTime.fromSeconds(seconds: self.alarmData.time_),
                weekday: dayOfWeek,
                title: "Routine: \(self.alarmData.name)",
                body: "Let's Begin!"
            )
            notificationIds.append(id)
        }
        self.alarmData.notificationIds = notificationIds
    }
}

struct AlarmEditor_Previewer: View {
    @State var inEditing: Bool = false
    @ObservedObject var alarmData: AlarmData
    var body: some View {
        AlarmEditor(
            inEditing: self.$inEditing,
            alarmData: alarmData
        )
    }
}

struct AlarmsEditor_Previews: PreviewProvider {
    static var previews: some View {
        let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let alarmData = AlarmData(context: moc)
        alarmData.id = UUID()
        alarmData.name = "Morning"
        alarmData.daysOfWeek_ = daysOfWeekToInt(daysOfWeek: [
            DayOfWeek.Monday,
            DayOfWeek.Tuesday,
            DayOfWeek.Wednesday,
            DayOfWeek.Thursday,
            DayOfWeek.Friday,
            DayOfWeek.Saturday,
            DayOfWeek.Sunday
        ])
        return AlarmEditor_Previewer(
            alarmData: alarmData
        )
    }
}
