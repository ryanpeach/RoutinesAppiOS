//
//  AlarmsRow.swift
//  Routines
//
//  Created by PEACH,RYAN (K-Atlanta,ex1) on 4/12/20.
//  Copyright © 2020 Peach. All rights reserved.
//

import SwiftUI
import CoreData


struct AlarmsRow: View {
    @ObservedObject var alarmData: AlarmData
    
    var body: some View {
        NavigationLink(destination: TaskListView(
            alarmData: self.alarmData
        )) {
            VStack() {
                HStack() {
                    Spacer()
                    Text(self.alarmData.name).font(Font.title)
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
        return AlarmsRow_Previewer(alarmData: alarmData)
    }
}
