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
    
    @ObservedObject var alarmData_: AlarmData

    @State var createMode = false
    @State var tag: TaskData?
    
    init(alarmData: AlarmData) {
        alarmData_ = alarmData
        resetCheckboxes()
    }
    
    var body: some View {
        VStack {
            Spacer().frame(height: DEFAULT_HEIGHT_SPACING)
            // Add Item Button
            NavigationLink(
                destination: TaskPlayerView(alarmData: alarmData_)
            ){
                HStack {
                    Text("Begin")
                    Image(systemName: "play")
                }
            }
            Spacer().frame(height: DEFAULT_HEIGHT_SPACING)
            List{
                ForEach(self.alarmData_.taskDataList, id: \.id) { td in
                    VStack {
                        TaskRowView(
                            tag: self.$tag,
                            taskData: td
                        )
                        /*
                        NavigationLink(destination: TaskPlayerView(
                            alarmData: self.alarmData_,
                            taskIndex: self.alarmData_.taskDataList.firstIndex(of: td) ?? 0
                        ), tag: td,
                           selection: self.$tag) {
                            EmptyView()
                        }
                        */
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
            managedObjectContext.delete(taskData)
        }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        var arr = self.alarmData_.taskDataList
        let element = arr.remove(at: source.first!)
        arr.insert(element, at: destination)
        
        var count = 0
        for td in arr {
            td.order = Int64(count)
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
