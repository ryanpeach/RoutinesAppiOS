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
    
    var alarmData: AlarmData
    
    @State var createMode = false
    @State var inEditing = false
    @State var taskPlayerIdx: Int = 0
    @State var taskEditUUID: UUID?
    
    var taskDataList: [TaskData] {
        return self.alarmData.taskDataList
    }
    
    var body: some View {
        VStack {
            // Spacer().frame(height: DEFAULT_HEIGHT_SPACING)
            // Add Item Button
            NavigationLink(
                destination: TaskPlayerView(
                    alarmData: self.alarmData,
                    taskIdx: self.taskPlayerIdx
                )
            ){
                HStack {
                    if self.taskPlayerIdx == 0 {
                        Text("Begin")
                    } else {
                        Text("Starting From: \(self.taskDataList[self.taskPlayerIdx].name)")
                    }
                    Image(systemName: "play")
                }
            }
            Spacer().frame(height: DEFAULT_HEIGHT_SPACING)
            List{
                ForEach(self.taskDataList, id: \.order) { td in
                    ZStack {
                        TaskRowView(
                            taskData: td,
                            inEditing: self.$inEditing,
                            taskEditUUID: self.$taskEditUUID,
                            taskPlayerIdx: self.$taskPlayerIdx
                        )
                    
                        NavigationLink(destination: TaskEditorView(
                                taskData: td
                        ), tag: td.id, selection: self.$taskEditUUID) {
                            EmptyView()
                        }
                    }
                }
                .onDelete(perform: self.delete)
                .onMove(perform: self.move)
            }
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
            }.sheet(isPresented: self.$createMode) {
                TaskCreatorView(
                    moc: self.managedObjectContext,
                    alarmData: self.alarmData,
                    createMode: self.$createMode,
                    order: self.taskDataList.count
                )
            }
        }
    }
    
    func createNewTask() {
        let taskData = TaskData(context: self.managedObjectContext)
        taskData.id = UUID()
        taskData.name = "New Task"
        taskData.duration_ = 0
        taskData.order = Int64(self.taskDataList.count)
        self.alarmData.addToTaskData(taskData)
        
        // Save
        self.save()
    }
    
    func delete(at offsets: IndexSet) {
        for index in offsets {
            let taskData = self.taskDataList[index]
            self.managedObjectContext.delete(taskData)
        }
        
        // Save
        self.save()
        self.alarmData.objectWillChange.send()
    }
    
    func move(from source: IndexSet, to destination: Int) {
        var range: [Int] = []
        var idx: Int = 0
        for _ in self.taskDataList {
            range.append(idx)
            idx += 1
        }
        
        range.move(fromOffsets: source, toOffset: destination)
        
        // Set the new order
        var count: Int = 0
        for idx in range {
            let td = self.taskDataList[idx]
            td.order = Int64(count)
            count += 1
        }
        
        // Update the order
        for td in self.taskDataList {
            td.objectWillChange.send()
        }
        
        // Save
        self.save()
        self.alarmData.objectWillChange.send()
    }
    
    func save() {
        do {
            try self.managedObjectContext.save()
        } catch let error {
            print("Could not save. \(error)")
        }
    }
    
}

struct TaskListView_Previewer: View {
    @ObservedObject var alarmData: AlarmData
    var body: some View {
        TaskListView(
            alarmData: self.alarmData
        )
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
