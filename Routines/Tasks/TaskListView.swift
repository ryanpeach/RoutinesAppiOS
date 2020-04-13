//
//  TaskListView.swift
//  Routines
//
//  Created by PEACH,RYAN (K-Atlanta,ex1) on 4/12/20.
//  Copyright © 2020 Peach. All rights reserved.
//

import SwiftUI

struct TaskListView: View {
    var name: String
    var taskList: Array<TaskData>
    
    var body: some View {
        List(self.taskList) { td in
            NavigationLink(destination: TaskDetailView(taskData: td)) {
                TaskRowView(taskData: td)
            }
        }
        .padding(10)
        .navigationBarTitle(Text(self.name))
    }
}

struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView(
            name: alarmData[0].name,
            taskList: alarmData[0].taskList
        )
    }
}
