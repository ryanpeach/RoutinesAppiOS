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
    
    @State var newTaskDataList: [TaskData] = []
    @State var createMode = false
    @State var inEditing = false
    @State var taskPlayerIdx: Int = 0
    @State var taskEditUUID: UUID?
    
    var taskDataList: [TaskData] {
        return self.alarmData.taskDataList
    }
    
    var body: some View {
        VStack {
            Spacer().frame(height: DEFAULT_HEIGHT_SPACING)
            // Add Item Button
            NavigationLink(
                destination: TaskPlayerView(
                    alarmData: self.alarmData,
                    taskIdx: self.taskPlayerIdx
                )
            ){
                HStack {
                    if self.taskPlayerIdx == 0 {
                        Text("Begin").font(.system(size: 22))
                    } else {
                        Text("Starting From: \(self.taskDataList[self.taskPlayerIdx].name)").font(.system(size: 22))
                    }
                    Image(systemName: "play")
                }
            }
            Spacer().frame(height: DEFAULT_HEIGHT_SPACING)
            List{
                ForEach(self.newTaskDataList, id: \.id) { td in
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
                    order: self.taskDataList.count,
                    onSave: {
                        self.newTaskDataList = self.alarmData.taskDataList
                    }
                )
            }
        }
        .navigationBarTitle(Text(self.alarmData.name))
        .navigationBarItems(trailing: EditButton())
        .onAppear {
            // Reset Checkboxes
            for td in self.taskDataList {
                td.resetDone()
            }
            self.save()
            
            // Reset self variables
            self.taskEditUUID = nil
            self.taskPlayerIdx = 0
            self.newTaskDataList = self.alarmData.taskDataList
        }
        .onDisappear {
            // self.newTaskDataList = []
            self.saveChanges()
        }
    }
    
    func saveChanges() {
        var count = 0
        for td in self.newTaskDataList {
            td.order = Int64(count)
            count += 1
        }
        self.save()
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
            self.newTaskDataList.remove(at: index)
            self.managedObjectContext.delete(taskData)
        }
        
        // Save
        self.save()
        // self.alarmData.objectWillChange.send()
    }
    
    func move(from source: IndexSet, to destination: Int) {
        self.newTaskDataList.move(fromOffsets: source, toOffset: destination)
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
        NavigationView {
            TaskListView(
                alarmData: self.alarmData
            )
        }
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
