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
    
    @State private var newSubTask: String = ""
    @State private var newName: String = ""
    @State private var newDuration: RelativeTime = RelativeTime.fromSeconds(seconds: 0)

    var body: some View {
        VStack {
            TextField(self.taskData.name,
                      text: self.$newName).frame(width: 100)
            Spacer().frame(height: 30)
            TimePickerRelativeView(time: self.$newDuration)
            Spacer().frame(height: 30)
            HStack {
                Spacer().frame(width: 30)
                TextField("Subtask Name", text: self.$newSubTask)
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
            Button(action: {
                withAnimation {
                    if self.newName != "" {
                        self.taskData.name = self.newName
                    }
                    self.taskData.duration_ = self.newDuration.timeInterval
                }
            }) {
                Text("Save")
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
        for index in source {
            let taskData = self.taskData.subTaskDataList[index]
            taskData.order = Int16(destination)
        }
    }
    
    func addSubTask() {
        let subTaskData = SubTaskData(context: self.managedObjectContext)
        subTaskData.id = UUID()
        subTaskData.order = Int16(self.taskData.subTaskDataList.count)
        subTaskData.name = self.newSubTask
        self.taskData.addToSubTaskData(subTaskData)
        
        // TODO: Add task names
        do {
            try self.managedObjectContext.save()
        } catch let error {
            print("Could not save. \(error)")
        }
    }
}

struct TaskEditorView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
