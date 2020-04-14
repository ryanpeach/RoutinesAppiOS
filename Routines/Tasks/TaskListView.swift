//
//  TaskListView.swift
//  Routines
//
//  Created by PEACH,RYAN (K-Atlanta,ex1) on 4/12/20.
//  Copyright © 2020 Peach. All rights reserved.
//

import SwiftUI

struct TaskListView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    var alarmData: AlarmData
    var taskDataList: [TaskData] {
        self.alarmData.getTaskDataList()
    }
    
    var body: some View {
        VStack {
            List{
                ForEach(self.taskDataList, id: \.id) { td in
                    TaskRowView(taskData: td)
                }
                .onDelete(perform: self.delete)
                .onMove(perform: self.move)
            }
            .padding(10)
            .navigationBarTitle(Text(self.alarmData.name!))
            .navigationBarItems(trailing: EditButton())
            
            // Add Item Button
            /*
            Button(
                action: {
                    withAnimation {
                        self.alarmData.taskList.append(
                            TaskData(
                                id: UUID(),
                                name: "New Task",
                                duration: RelativeTime.fromSeconds(seconds: 0.0),
                                subtasks: []
                            )
                        )
                    }
                }
            ) {
                HStack {
                    Text("Add Item")
                    Image(systemName: "plus")
                }
            }
             */
        }
        
    }
    
    func delete(at offsets: IndexSet) {
        for index in offsets {
            let taskData = taskDataList[index]
            managedObjectContext.delete(taskData)
        }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        for index in source {
            let taskData = taskDataList[index]
            taskData.order = Int16(destination)
        }
    }
}
