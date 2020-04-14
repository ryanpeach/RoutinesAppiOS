//
//  AlarmsRow.swift
//  Routines
//
//  Created by PEACH,RYAN (K-Atlanta,ex1) on 4/12/20.
//  Copyright © 2020 Peach. All rights reserved.
//

import SwiftUI
import CoreData


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
            if (self.daysOfWeek.contains(DayOfWeek.Saturday)) {
                Text("Sat")
            }
            if (self.daysOfWeek.contains(DayOfWeek.Sunday)) {
                Text("Sun")
            }
        }
    }
}

struct AlarmsRow: View {
    @ObservedObject var alarmData: AlarmData
    
    var body: some View {
        NavigationLink(destination: TaskListView(
            alarmData: self.alarmData
        )) {
            VStack() {
                HStack() {
                    Spacer()
                    Text(self.alarmData.name)
                    Spacer()
                    VStack {
                        HStack{
                            Spacer()
                            Text("Time: ")
                            Text(self.alarmData.time.stringHMS())
                        }
                        HStack {
                            Spacer()
                            Text("Duration: ")
                            Text(self.alarmData.duration.stringHMS())
                        }
                    }
                }
                Spacer().frame(height: 20)
                DaysOfWeekView(daysOfWeek: Set(self.alarmData.daysOfWeek))
            }
        }
    }
}

struct AlarmsRow_Previewer: View {
    @State var alarmData: AlarmData
    var body: some View {
        AlarmsRow(alarmData: alarmData)
    }
}

struct AlarmsRow_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    static var previews: some View {
        let alarmData = AlarmData(context: moc)
        alarmData.id = UUID()
        alarmData.name = "Morning"
        alarmData.daysOfWeek_ = daysOfWeekToInt(daysOfWeek: [
            DayOfWeek.Monday,
            DayOfWeek.Tuesday,
            DayOfWeek.Wednesday,
            DayOfWeek.Thursday,
            DayOfWeek.Friday
        ])
        return AlarmsRow_Previewer(alarmData: alarmData)
    }
}
