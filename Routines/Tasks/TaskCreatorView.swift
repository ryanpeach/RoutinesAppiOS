//
//  TaskCreationView.swift
//  Routines
//
//  Created by PEACH,RYAN (K-Atlanta,ex1) on 4/13/20.
//  Copyright © 2020 Peach. All rights reserved.
//

import SwiftUI


struct TaskCreatorView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @Binding var createMode: Bool
    
    @State private var name: String = "New Task"
    @State private var duration: RelativeTime = RelativeTime.fromSeconds(seconds: 0)
    
    @State var newSubTask: String = ""
    @State var subTaskDataList: [String] = []

    var body: some View {
        VStack {
            TitleTextField(text: self.$name)
            Spacer().frame(height: 30)
            TimePickerRelativeView(time: self.$duration)
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
        .navigationBarItems(
            trailing: EditButton()
        )
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
        let task = TaskData(context: self.managedObjectContext)
        task.id = UUID()
        task.name = self.name
        task.duration = self.duration
        
        var order = 0
        for sub_task_name in self.subTaskDataList {
            let sub_task = SubTaskData(context: self.managedObjectContext)
            sub_task.id = UUID()
            sub_task.name = sub_task_name
            sub_task.order = Int16(order)
            task.addToSubTaskData(sub_task)
            order += 1
        }
        
        // Save
        do {
            try self.managedObjectContext.save()
        } catch let error {
            print("Could not save. \(error)")
        }
        
        // Bring me back
        self.createMode = false        // Save
    }
}


struct TaskCreatorView_Previewer: View {
    @State var createMode = true
    var body: some View {
        TaskCreatorView(createMode: self.$createMode)
    }
}

struct TaskCreatorView_Previews: PreviewProvider {
    static var previews: some View {
        TaskCreatorView_Previewer()
    }
}
