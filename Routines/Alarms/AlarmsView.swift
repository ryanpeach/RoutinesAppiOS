//
//  ContentView.swift
//  Routines
//
//  Created by PEACH,RYAN (K-Atlanta,ex1) on 4/12/20.
//  Copyright © 2020 Peach. All rights reserved.
//

import SwiftUI

struct AlarmsView: View {
    var body: some View {
        NavigationView {
            List(alarmData) { al in
                NavigationLink(destination: TaskListView(
                    name: al.name,
                    taskList: al.taskList
                )) {
                    AlarmsRow(alarm: al)
                }
            }
            .padding(10)
            .navigationBarTitle(Text("Alarms"))
        }
    }
}

struct AlarmsView_Previews: PreviewProvider {
    static var previews: some View {
        AlarmsView()
    }
}
