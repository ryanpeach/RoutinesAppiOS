//
//  TaskListView.swift
//  Routines
//
//  Created by PEACH,RYAN (K-Atlanta,ex1) on 4/12/20.
//  Copyright © 2020 Peach. All rights reserved.
//

import SwiftUI
import CoreData

struct TaskListView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @ObservedObject var alarmData: AlarmData
    
    var body: some View {
        return VStack {
            List{
                ForEach(self.alarmData.taskDataList) { td in
                    TaskRowView(taskData: td)
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
                    let taskData = TaskData(context: self.managedObjectContext)
                    taskData.id = UUID()
                    taskData.name = "New Task"
                    taskData.duration_ = 0
                    self.alarmData.addToTaskData(taskData)
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
        for index in offsets {
            let taskData = self.alarmData.taskDataList[index]
            managedObjectContext.delete(taskData)
        }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        for index in source {
            let taskData = self.alarmData.taskDataList[index]
            taskData.order = Int16(destination)
        }
    }
}

struct TaskListView_Previewer: View {
    @State var alarmData: AlarmData
    var body: some View {
        TaskListView(alarmData: alarmData)
    }
}

struct TaskListView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    static var previews: some View {
        let alarmData = AlarmData(context: moc)
        alarmData.id = UUID()
        alarmData.name = "Morning"
        let taskData = TaskData(context: moc)
        taskData.id = UUID()
        taskData.name = "Get out of bed."
        alarmData.addToTaskData(taskData)
        return TaskListView_Previewer(alarmData: alarmData)
    }
}
