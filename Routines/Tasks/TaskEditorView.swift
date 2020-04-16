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

    var body: some View {
        VStack {
            TitleTextField(text: self.$taskData.name)
            Spacer().frame(height: 30)
            TimePickerRelativeView(time: self.$taskData.duration)
            Spacer().frame(height: 30)
            HStack {
                Spacer().frame(width: 30)
                ReturnTextField(
                    label: "New Subtask",
                    text: self.$newSubTask,
                    onCommit: self.addSubTask
                )
                Button(action: {
                    self.addSubTask()
                }) {
                    Image(systemName: "plus")
                        .frame(width: 30, height: 30)
                }
                Spacer().frame(width: 30)
            }
            Spacer().frame(height: 30)
            Text("Subtasks:")
            Spacer().frame(height: 15)
            List {
                ForEach(self.taskData.subTaskDataList, id: \.id) { sub_td in
                    Text(sub_td.name)
                }
                .onDelete(perform: self.delete)
                .onMove(perform: self.move)
            }
        }
        .navigationBarItems(
            trailing: EditButton()
        )
    }
    
    func delete(at offsets: IndexSet) {
        for index in offsets {
            let taskData = self.taskData.subTaskDataList[index]
            managedObjectContext.delete(taskData)
        }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        var arr = self.taskData.subTaskDataList
        let element = arr.remove(at: source.first!)
        arr.insert(element, at: destination)
        
        var count = 0
        for sub_td in arr {
            sub_td.order = Int16(count)
            count += 1
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
            subTaskData.order = Int16(self.taskData.subTaskDataList.count)
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

struct TaskEditorView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
