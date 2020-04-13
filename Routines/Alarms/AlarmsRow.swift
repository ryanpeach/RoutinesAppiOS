//
//  AlarmsRow.swift
//  Routines
//
//  Created by PEACH,RYAN (K-Atlanta,ex1) on 4/12/20.
//  Copyright © 2020 Peach. All rights reserved.
//

import SwiftUI



struct DaysOfWeekView: View {
    var daysOfWeek: Set<DayOfWeek>
    
    var body: some View {
        HStack {
            // I did it this way so you can apply style
            // changes to each of the days of the week
            // And to preserver proper ordering and string
            // conversion
            if (self.daysOfWeek.contains(DayOfWeek.Monday)) {
                Text("Mon")
            }
            if (self.daysOfWeek.contains(DayOfWeek.Tuesday)) {
                Text("Tue")
            }
            if (self.daysOfWeek.contains(DayOfWeek.Wednesday)) {
                Text("Wed")
            }
            if (self.daysOfWeek.contains(DayOfWeek.Thursday)) {
                Text("Thu")
            }
            if (self.daysOfWeek.contains(DayOfWeek.Friday)) {
                Text("Fri")
            }
            if (self.daysOfWeek.contains(DayOfWeek.Satuday)) {
                Text("Sat")
            }
            if (self.daysOfWeek.contains(DayOfWeek.Sunday)) {
                Text("Sun")
            }
        }
    }
}

struct AlarmsRow: View {
    let alarmId: UUID
    
    @Binding private var alarmData: AlarmData
    
    var body: some View {
        NavigationLink(destination: TaskListView(
            alarmId: self.alarmId
        )) {
            VStack() {
                HStack() {
                    Spacer()
                    Text(self.alarm.name)
                    Spacer()
                    VStack {
                        HStack{
                            Spacer()
                            Text("Time: ")
                            Text(self.alarm.time.stringHMS())
                        }
                        HStack {
                            Spacer()
                            Text("Duration: ")
                            Text(self.alarm.getDuration().stringHMS())
                        }
                    }
                }
                Spacer().frame(height: 20)
                DaysOfWeekView(daysOfWeek: self.alarm.daysOfWeek)
            }
    //        .overlay(
    //            RoundedRectangle(cornerRadius: 16)
    //                .stroke(Color.black, lineWidth: 4)
    //        )
        }
    }
}


struct AlarmsRow_Previews: PreviewProvider {
    static var previews: some View {
        AlarmsRow(alarmData: alarmDataList[0].id)
    }
}
