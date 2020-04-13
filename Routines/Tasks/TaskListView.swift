//
//  TaskListView.swift
//  Routines
//
//  Created by PEACH,RYAN (K-Atlanta,ex1) on 4/12/20.
//  Copyright © 2020 Peach. All rights reserved.
//

import SwiftUI

struct TaskListView: View {
    let alarmId: UUID
    
    @Binding private var alarmData: alarmData
    
    var body: some View {
        VStack {
            List{
                ForEach(self.alarmData.taskList.indices) { idx in
                    TaskRowView(taskData: self.$alarmData.taskList[idx])
                }
                .onDelete(perform: self.delete)
                .onMove(perform: self.move)
            }
            .padding(10)
            .navigationBarTitle(Text(self.alarmData.name))
            .navigationBarItems(trailing: EditButton())
            
            // Add Item Button
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
        }
        
    }
    
    func delete(at offsets: IndexSet) {
        self.alarmData.taskList.remove(atOffsets: offsets)
    }
    
    func move(from source: IndexSet, to destination: Int) {
        self.alarmData.taskList.move(fromOffsets: source, toOffset: destination)
    }
}

struct TaskListView_Previewer: View {
    @State var alarmData: AlarmData
    
    var body: some View {
        NavigationView {
            TaskListView(
                alarmData: self.$alarmData
            )
        }
    }
}

struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView_Previewer(alarmData: alarmDataList[0])
    }
}
