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
    
    @Binding var inEditing: Bool
    @ObservedObject var taskData: TaskData
    @State var newSubTask: String = ""

    var body: some View {
        VStack {
            TitleTextField(text: self.$taskData.name)
            Spacer().frame(height: DEFAULT_HEIGHT_SPACING)
            TimePickerRelativeView(time: self.$taskData.duration)
            Spacer().frame(height: DEFAULT_HEIGHT_SPACING)
            HStack {
                Spacer().frame(width: DEFAULT_LEFT_ALIGN_SPACE, height: DEFAULT_HEIGHT_SPACING)
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
                Spacer().frame(width: DEFAULT_HEIGHT_SPACING)
            }
            Spacer().frame(height: DEFAULT_HEIGHT_SPACING)
            Text("Subtasks:")
            Spacer().frame(height: DEFAULT_HEIGHT_SPACING)
            List {
                ForEach(self.taskData.subTaskDataList, id: \.id) { sub_td in
                    Text(sub_td.name)
                }
                .onDelete(perform: self.delete)
                .onMove(perform: self.move)
            }
        }
        .navigationBarBackButtonHidden(true) // not needed, but just in case
        .navigationBarItems(
            leading: MyBackButton(label: "Back") {
                self.inEditing.toggle()
            },
            trailing: EditButton()
        )
    }
    
    func delete(at offsets: IndexSet) {
        for index in offsets {
            let taskData = self.taskData.subTaskDataList[index]
            taskData.delete(moc: self.managedObjectContext)
        }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        var arr = self.taskData.subTaskDataList
        let element = arr.remove(at: source.first!)
        arr.insert(element, at: destination)
        
        // Reindex
        // TODO: Better reindexing
        var count = 0
        for sub_td in arr {
            sub_td.order = Int64(count)
            count += 1
        }
        
        // Save
        do {
            try self.managedObjectContext.save()
        } catch let error {
            print("Could not save. \(error)")
        }
        
        self.taskData.objectWillChange.send()
        self.taskData.alarmData.objectWillChange.send()
    }
    
    func addSubTask() {
        if self.newSubTask != "" {
            let subTaskData = SubTaskData(context: self.managedObjectContext)
            subTaskData.id = UUID()
            subTaskData.order = Int64(self.taskData.subTaskDataList.count)
            subTaskData.name = self.newSubTask
            self.taskData.addToSubTaskData(subTaskData)
            
            // Save
            do {
                try self.managedObjectContext.save()
            } catch let error {
                print("Could not save. \(error)")
            }
            
            // Delete the item in the new sub task
            self.newSubTask = ""
        }
    }
    
}

struct TaskEditorView_Previewer: View {
    @State var inEditing: Bool = true
    @ObservedObject var taskData: TaskData
    var body: some View {
        TaskEditorView(
            inEditing: self.$inEditing,
            taskData: self.taskData
        )
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
