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
    @FetchRequest(
        entity: TaskData.entity(),
        sortDescriptors: [
            NSSortDescriptor(
                keyPath: \TaskData.order,
                ascending: true
            )
    ]) var taskDataListUnfiltered: FetchedResults<TaskData>

    @ObservedObject var alarmData_: AlarmData
    
    @State var createMode = false
    @State var inEditing = false
    @State var taskPlayerIdx: Int = 0
    @State var taskEditUUID: UUID?
    
    var taskDataList: [TaskData] {
        var out: [TaskData] = []
        for td in taskDataListUnfiltered {
            if td.alarmData.id == self.alarmData_.id {
                out.append(td)
            }
        }
        return out
    }
    
    
    init(alarmData: AlarmData) {
        alarmData_ = alarmData
        resetCheckboxes()
    }
    
    var body: some View {
        VStack {
            // Spacer().frame(height: DEFAULT_HEIGHT_SPACING)
            // Add Item Button
            NavigationLink(
                destination: TaskPlayerView(
                    alarmData: self.alarmData_,
                    taskIdx: self.$taskPlayerIdx
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
            .navigationBarTitle(Text(self.alarmData_.name))
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
                    alarmData: self.alarmData_,
                    createMode: self.$createMode,
                    order: self.alarmData_.taskDataList.count
                )
            }
        }
    }
    
    func createNewTask() {
        let taskData = TaskData(context: self.managedObjectContext)
        taskData.id = UUID()
        taskData.name = "New Task"
        taskData.duration_ = 0
        taskData.order = Int64(self.alarmData_.taskDataList.count)
        self.alarmData_.addToTaskData(taskData)
        
        // Save
        do {
            try self.managedObjectContext.save()
        } catch let error {
            print("Could not save. \(error)")
        }
    }
    
    func resetCheckboxes() {
        let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        for taskData in alarmData_.taskDataList {
            taskData.resetDone()
        }
        
        // Save
        do {
            try moc.save()
        } catch let error {
            print("Could not save. \(error)")
        }
    }
    
    
    func delete(at offsets: IndexSet) {
        for index in offsets {
            let taskData = self.alarmData_.taskDataList[index]
            self.managedObjectContext.delete(taskData)
        }
        
        // Save
        /*
        do {
            try self.managedObjectContext.save()
        } catch let error {
            print("Could not save. \(error)")
        }
        */
    }
    
    func move(from source: IndexSet, to destination: Int) {
        var range: [Int] = []
        var idx: Int = 0
        for _ in self.taskDataList {
            range.append(idx)
            idx += 1
        }
        
        let element = range.remove(at: source.first!)
        range.insert(element, at: destination)
        
        var count: Int = 0
        for idx in range {
            self.taskDataList[idx].order = Int64(count)
            count += 1
        }
        
        // Save
        do {
            try self.managedObjectContext.save()
        } catch let error {
            print("Could not save. \(error)")
        }
        
        self.alarmData_.objectWillChange.send()
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
