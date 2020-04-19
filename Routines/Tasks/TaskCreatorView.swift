//
//  TaskCreationView.swift
//  Routines
//
//  Created by PEACH,RYAN (K-Atlanta,ex1) on 4/13/20.
//  Copyright © 2020 Peach. All rights reserved.
//

import SwiftUI
import CoreData

struct NewSubTaskView: View {
    @Binding var newSubTask: String
    var addSubTask: () -> ()
    
    var body: some View {
        HStack {
            Spacer().frame(width: DEFAULT_LEFT_ALIGN_SPACE)
            ReturnTextField(
                label: "New Subtask",
                text: self.$newSubTask,
                onCommit: self.addSubTask
            )
            Button(action: {
                self.addSubTask()
            }) {
                Image(systemName: "plus")
                    .frame(width: DEFAULT_LEFT_ALIGN_SPACE, height: 30)
            }
            Spacer().frame(width: DEFAULT_LEFT_ALIGN_SPACE)
        }
    }
}
struct TaskCreatorView: View {
    var moc: NSManagedObjectContext
    
    @ObservedObject var alarmData: AlarmData
    
    @Binding var createMode: Bool
    let order: Int
    
    @State private var name: String = "New Task"
    @State private var duration: RelativeTime = RelativeTime.fromSeconds(seconds: 0)
    
    @State var newSubTask: String = ""
    @State var subTaskDataList: [String] = []

    var body: some View {
        VStack {
            Spacer().frame(height: DEFAULT_HEIGHT_SPACING)
            VStack {
                TitleTextField(text: self.$name)
                Spacer().frame(height: DEFAULT_HEIGHT_SPACING)
                TimePickerRelativeView(time: self.$duration)
                Spacer().frame(height: DEFAULT_HEIGHT_SPACING)
                NewSubTaskView(newSubTask: self.$newSubTask, addSubTask: self.addSubTask)
                Spacer().frame(height: DEFAULT_HEIGHT_SPACING)
                Text("Subtasks:")
                Spacer().frame(height: DEFAULT_HEIGHT_SPACING)
                List {
                    ForEach(self.subTaskDataList, id: \.self) { sub_td in
                        Text(sub_td)
                    }
                    .onDelete(perform: self.delete)
                    .onMove(perform: self.move)
                }
                Button(action: {
                    self.done()
                }) {
                    Text("Save")
                }
            }
            Spacer()
        }
    }
    
    func delete(at offsets: IndexSet) {
        for at in offsets {
            self.subTaskDataList.remove(at: at)
        }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        self.subTaskDataList.move(fromOffsets: source, toOffset: destination)
    }
    
    func addSubTask() {
        if self.newSubTask != "" {
            self.subTaskDataList.append(self.newSubTask)
            
            // Delete the item in the new sub task
            self.newSubTask = ""
        }
    }
    
    func done() {
        let task = TaskData(context: self.moc)
        task.id = UUID()
        task.name = self.name
        task.order = Int64(self.order)
        task.duration = self.duration
        self.alarmData.addToTaskData(task)
        
        var order = 0
        for sub_task_name in self.subTaskDataList {
            let sub_task = SubTaskData(context: self.moc)
            sub_task.id = UUID()
            sub_task.name = sub_task_name
            sub_task.order = Int64(order)
            task.addToSubTaskData(sub_task)
            order += 1
        }
        
        // Save
        do {
            try self.moc.save()
        } catch let error {
            print("Could not save. \(error)")
        }
        
        // Bring me back
        self.createMode = false        // Save
    }
}


struct TaskCreatorView_Previewer: View {
    @Environment(\.managedObjectContext) private var managedObjectContext
    @ObservedObject var alarmData: AlarmData
    @State var createMode = true
    var body: some View {
        TaskCreatorView(
            moc: managedObjectContext,
            alarmData: self.alarmData,
            createMode: self.$createMode,
            order: 1
        )
    }
}

struct TaskCreatorView_Previews: PreviewProvider {
    static var previews: some View {
        let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let alarmData = AlarmData(context: moc)
        alarmData.id = UUID()
        alarmData.name = "Morning"
        alarmData.daysOfWeek_ = daysOfWeekToInt(daysOfWeek: [
            DayOfWeek.Monday,
            DayOfWeek.Tuesday,
            DayOfWeek.Wednesday,
            DayOfWeek.Thursday,
            DayOfWeek.Friday
        ])
        return TaskCreatorView_Previewer(alarmData: alarmData)
    }
}
