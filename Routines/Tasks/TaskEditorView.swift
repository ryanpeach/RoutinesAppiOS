//
//  TaskCreationView.swift
//  Routines
//
//  Created by PEACH,RYAN (K-Atlanta,ex1) on 4/13/20.
//  Copyright © 2020 Peach. All rights reserved.
//

import SwiftUI


struct TaskEditorView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @ObservedObject var taskData: TaskData
    @State var newSubTask: String = ""
    @State var taskName: String = ""
    @State var newSubTaskDataList: [String] = []
    @State var taskDuration: RelativeTime = RelativeTime.fromSeconds(seconds: 0)
    
    var body: some View {
        VStack {
            TitleTextField(text: self.$taskName)
            Spacer().frame(height: DEFAULT_HEIGHT_SPACING)
            TimePickerRelativeView(time: self.$taskDuration)
            Spacer().frame(height: DEFAULT_HEIGHT_SPACING)
            NewSubTaskView(
                newSubTask: self.$newSubTask,
                addSubTask: self.addSubTask
            )
            Spacer().frame(height: DEFAULT_HEIGHT_SPACING)
            Text("Subtasks:")
            Spacer().frame(height: DEFAULT_HEIGHT_SPACING)
            List {
                ForEach(self.newSubTaskDataList, id: \.self) { sub_td_name in
                    Text(sub_td_name)
                }
                .onDelete(perform: self.delete)
                .onMove(perform: self.move)
            }
            .navigationBarItems(trailing: EditButton())
        }
        .onAppear {
            self.taskName = self.taskData.name
            self.taskDuration = self.taskData.duration
            self.newSubTaskDataList = []
            for sub_td in self.taskData.subTaskDataList {
                self.newSubTaskDataList.append(sub_td.name)
            }
        }
        .onDisappear {
            self.taskData.name = self.taskName
            self.taskData.duration = self.taskDuration
            self.addSubTasks()
            // Save
            self.save()
        }
    }
    
    func delete(at offsets: IndexSet) {
        for i in offsets {
            self.newSubTaskDataList.remove(at: i)
        }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        self.newSubTaskDataList.move(fromOffsets: source, toOffset: destination)
    }
    
    func addSubTask() {
        if self.newSubTask != "" {
            self.newSubTaskDataList.append(self.newSubTask)
            
            // Delete the item in the new sub task
            self.newSubTask = ""
        }
    }
    
    func addSubTasks() {
        for sub_td in self.taskData.subTaskDataList {
            self.managedObjectContext.delete(sub_td)
        }
        var order: Int = 0
        for sub_td_name in self.newSubTaskDataList {
            let subTaskData = SubTaskData(context: self.managedObjectContext)
            subTaskData.id = UUID()
            subTaskData.name = sub_td_name
            subTaskData.order = Int64(order)
            self.taskData.addToSubTaskData(subTaskData)
            order += 1
        }
    }
    
    func save() {
        // Save
        do {
            try self.managedObjectContext.save()
        } catch let error {
            print("Could not save. \(error)")
        }
    }
    
}

struct TaskEditorView_Previewer: View {
    @State var inEditing: Bool = true
    @ObservedObject var taskData: TaskData
    var body: some View {
        NavigationView {
            TaskEditorView(
                taskData: self.taskData
            )
        }
    }
}

struct TaskDataView_Previews: PreviewProvider {
    static var previews: some View {
        let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let alarmData = AlarmData(context: moc)
        alarmData.id = UUID()
        alarmData.name = "Morning"
        let taskData = TaskData(context: moc)
        taskData.id = UUID()
        taskData.name = "Get out of bed."
        alarmData.addToTaskData(taskData)
        return TaskEditorView_Previewer(taskData: taskData)
    }
}
