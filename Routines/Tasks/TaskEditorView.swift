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
    @State private var newName: String = ""
    @State private var newDuration: RelativeTime = RelativeTime.fromSeconds(seconds: 0)
    
    
    var body: some View {
        VStack {
            TextField(self.taskData.name,
                      text: self.$newName)
            Spacer().frame(height: 30)
            TimePickerRelativeView(time: self.$newDuration)
            Spacer().frame(height: 30)
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
            Spacer().frame(height: 30)
            Text("Subtasks:")
            Spacer().frame(height: 15)
            List {
                ForEach(self.taskData.subTaskDataList, id: \.id) { sub_td in
                    Text(sub_td.name)
                }
                //.onDelete(perform: self.delete)
                //.onMove(perform: self.move)
            }
            .navigationBarItems(
                trailing: EditButton()
            )
            Button(action: {}) {
                HStack {
                    Text("This is where a text field goes.")
                    Image(systemName: "plus")
                }
            }
        }
    }
    /*
    func delete(at offsets: IndexSet) {
        for index in offsets {
            let taskData = taskDataList[index]
            managedObjectContext.delete(taskData)
        }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        for index in source {
            let taskData = taskDataList[index]
            taskData.order = Int16(destination)
        }
    }
    
    func addItem(text: String) {
        let taskData = TaskData(context: self.managedObjectContext)
        taskData.id = UUID()
        taskData.order = taskDataList.count
        taskData.name = self.newName
        // TODO: Add task names
    }
     */
}

struct TaskEditorView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
