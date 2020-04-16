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
    
    @ObservedObject var alarmData: AlarmData
    
    var body: some View {
        VStack {
            Spacer()
            //TitleTextField(text: self.$alarmData.name)
            //Spacer().frame(height: 30)
            //TimePickerAbsolute(currentDate: self.$alarmData.time)
            DaysOfWeekPicker(daysOfWeek: self.$alarmData.daysOfWeek)
            Spacer()
        }
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
        return AlarmEditor(alarmData: alarmData)
    }
}
