//
//  TaskCreationView.swift
//  Routines
//
//  Created by PEACH,RYAN (K-Atlanta,ex1) on 4/13/20.
//  Copyright © 2020 Peach. All rights reserved.
//

import SwiftUI


struct TaskCreationView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        entity: AlarmData.entity(),
        sortDescriptors: [
            NSSortDescriptor(
                keyPath: \AlarmData.time_,
                ascending: true
            )
    ]) var alarmDataList: FetchedResults<AlarmData>
    
    let taskId: UUID
    @State private var isShowingAlert = false
    
    var body: some View {
        VStack {
            Spacer().frame(height: 30)
            TimePickerRelativeView(time: self.$taskData.duration)
            Spacer().frame(height: 30)
            Text("Subtasks:")
            Spacer().frame(height: 15)
            List {
                ForEach(self.taskData.subTaskData, id: \.id) { sub_td in
                    Text(sub_td.name)
                }
                .onDelete(perform: self.delete)
                .onMove(perform: self.move)
            }
            .navigationBarTitle(Text("Editing: "+self.taskData.name))
            .navigationBarItems(
                trailing: EditButton()
            )
            Button(action: {
                withAnimation {
                    self.isShowingAlert.toggle()
                }
            }) {
                HStack {
                    Text("Add Item")
                    Image(systemName: "plus")
                }
            }
        }
        .textFieldAlert(
            isShowing: $isShowingAlert,
            action: self.addItem,
            title: "New Task:"
        )
    }
    
    func delete(at offsets: IndexSet) {
        for index in offsets {
            let alarmData = alarmDataList[index]
            managedObjectContext.delete(alarmData)
        }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        self.taskData.subtasks.move(fromOffsets: source, toOffset: destination)
    }
    
    func addItem(text: String) {
        self.taskData.subtasks.append(SubTaskData(
                id: UUID(),
                name: text
            )
        )
    }
}

struct TaskCreationView_Previewer: View {
    @State var taskData: TaskData
    
    var body: some View {
        TaskEditorView(taskData: self.$taskData)
    }
}

struct TaskCreationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TaskCreationView_Previewer(
                taskData: alarmDataList[0].taskList[1]
            )
        }
    }
}
