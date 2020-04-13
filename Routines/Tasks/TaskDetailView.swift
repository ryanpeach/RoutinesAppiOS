//
//  TaskDetailView.swift
//  Routines
//
//  Created by PEACH,RYAN (K-Atlanta,ex1) on 4/12/20.
//  Copyright © 2020 Peach. All rights reserved.
//

import SwiftUI

struct TaskDetailView: View {
    let alarmId: UUID
    let taskId: UUID
    
    @Binding private var taskData: TaskData
    
    var body: some View {
        VStack {
            Text(taskData.duration.stringMS())
            List (taskData.subtasks) { sub_td in
                Text(sub_td.name)
            }
            .navigationBarTitle(Text(self.taskData.name))
            .navigationBarItems(
                trailing:
                NavigationLink(destination: TaskEditorView(taskData: $taskData)) {
                    Text("Edit")
                }
            )
        }
    }
}

struct TaskDetailView_Previewer: View {
    @State var taskData: TaskData
    
    var body: some View {
        NavigationView {
            TaskDetailView(
                taskData: self.$taskData
            )
        }
    }
}

struct TaskDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TaskDetailView_Previewer(taskData: alarmDataList[0].taskList[1])
    }
}
