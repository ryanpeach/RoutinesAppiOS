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
    @FetchRequest(
        entity: SubTaskData.entity(),
        sortDescriptors: [
            NSSortDescriptor(
                keyPath: \SubTaskData.order,
                ascending: true
            )
    ]) var subTaskDataListUnfiltered: FetchedResults<SubTaskData>
    
    var subTaskDataList: [SubTaskData] {
        var out: [SubTaskData] = []
        for sub_td in subTaskDataListUnfiltered {
            if sub_td.taskData.id == self.taskData.id {
                out.append(sub_td)
            }
        }
        return out
    }
    
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
                ForEach(self.subTaskDataList, id: \.id) { sub_td in
                    Text(sub_td.name)
                }
                .onDelete(perform: self.delete)
                .onMove(perform: self.move)
            }
        }
        .navigationBarItems(trailing: EditButton())
    }
    
    func delete(at offsets: IndexSet) {
        for index in offsets {
            let subTaskData = self.subTaskDataList[index]
            self.managedObjectContext.delete(subTaskData)
        }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        var range: [Int] = []
        var idx: Int = 0
        for _ in self.subTaskDataList {
            range.append(idx)
            idx += 1
        }
        
        range.move(fromOffsets: source, toOffset: destination)
        
        // Set the new order
        var count: Int = 0
        for idx in range {
            let td = self.subTaskDataList[idx]
            td.order = Int64(count)
            count += 1
        }
        
        // Update the order
        for sub_td in self.subTaskDataList {
            sub_td.objectWillChange.send()
        }
        
        // Save
        do {
            try self.managedObjectContext.save()
        } catch let error {
            print("Could not save. \(error)")
        }
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
