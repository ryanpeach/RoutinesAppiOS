//
//  TaskDetailView.swift
//  Routines
//
//  Created by PEACH,RYAN (K-Atlanta,ex1) on 4/12/20.
//  Copyright © 2020 Peach. All rights reserved.
//

import SwiftUI

struct TaskDetailView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        entity: TaskData.entity(),
        sortDescriptors: [
            NSSortDescriptor(
                keyPath: \TaskData.id,
                ascending: true
            )
    ]) var taskDataList: FetchedResults<AlarmData>
    
    let taskData: TaskData
    
    var body: some View {
        VStack {
            Text(taskData.duration.stringMS())
            List (taskData.subTaskData, id: \.id) { sub_td in
                Text(sub_td.name)
            }
            .navigationBarTitle(Text(self.taskData.name))
            .navigationBarItems(
                trailing:
                NavigationLink(destination: TaskEditorView(taskId: taskData.id)) {
                    Text("Edit")
                }
            )
        }
    }
}
