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
    @Environment(\.editMode) var editMode
    
    @ObservedObject var alarmData: AlarmData
    
    @State var createMode = false
    
    var body: some View {
        VStack {
            // Add Item Button
            NavigationLink(
                destination: TaskPlayerView(alarmData: alarmData)
                )
                {
                HStack {
                    Text("Begin")
                    Image(systemName: "play")
                }
            }
            
            List{
                ForEach(self.alarmData.taskDataList) { td in
                    NavigationLink(
                        destination: TaskEditorView(taskData: td)
                    ) {
                        TaskRowView(taskData: td)
                    }
                }
                .onDelete(perform: self.delete)
                .onMove(perform: self.move)
            }
            .padding(10)
            .navigationBarTitle(Text(self.alarmData.name))
            .navigationBarItems(trailing: EditButton())
            
            // Add Item Button
            Button(action: {
                self.createMode = true
            }) {
                HStack {
                    Text("Add Item")
                    Image(systemName: "plus")
                }
            }
            NavigationLink(
                destination: TaskCreatorView(
                    alarmData: self.alarmData,
                    createMode: $createMode,
                    order: self.alarmData.taskDataList.count
                ),
                isActive: $createMode
            ) { EmptyView() }
        }
    }
    
    func createNewTask() {
        let taskData = TaskData(context: self.managedObjectContext)
        taskData.id = UUID()
        taskData.name = "New Task"
        taskData.duration_ = 0
        taskData.order = Int16(self.alarmData.taskDataList.count)
        self.alarmData.addToTaskData(taskData)
        
        // Save
        do {
            try self.managedObjectContext.save()
        } catch let error {
            print("Could not save. \(error)")
        }
    }
    
    func delete(at offsets: IndexSet) {
        for index in offsets {
            let taskData = self.alarmData.taskDataList[index]
            managedObjectContext.delete(taskData)
        }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        var arr = self.alarmData.taskDataList
        let element = arr.remove(at: source.first!)
        arr.insert(element, at: destination)
        
        var count = 0
        for td in arr {
            td.order = Int16(count)
            count += 1
        }
        
        // Save
        do {
            try self.managedObjectContext.save()
        } catch let error {
            print("Could not save. \(error)")
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
