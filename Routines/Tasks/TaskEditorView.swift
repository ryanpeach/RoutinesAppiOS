//
//  TaskCreationView.swift
//  Routines
//
//  Created by PEACH,RYAN (K-Atlanta,ex1) on 4/13/20.
//  Copyright © 2020 Peach. All rights reserved.
//

import SwiftUI

// REF: https://stackoverflow.com/questions/56726663/how-to-add-a-textfield-to-alert-in-swiftui
struct TextFieldAlert<Presenting>: View where Presenting: View {

    @Binding var isShowing: Bool
    
    let action: (String) -> ()
    let presenting: Presenting
    let title: String
    
    @State private var text: String = ""

    var body: some View {
        GeometryReader { (deviceSize: GeometryProxy) in
            ZStack {
                self.presenting
                    .disabled(self.isShowing)
                VStack {
                    Text(self.title)
                    TextField("", text: self.$text)
                    Divider()
                    HStack {
                        Button(action: {
                            withAnimation {
                                self.isShowing.toggle()
                                if !self.text.isEmpty {
                                    self.action(self.text)
                                }
                            }
                        }) {
                            Text("Save")
                        }
                    }
                }
                .padding()
                .background(Color.white)
                .frame(
                    width: deviceSize.size.width*0.7,
                    height: deviceSize.size.height*0.7
                )
                .shadow(radius: 1)
                .opacity(self.isShowing ? 1 : 0)
            }
        }
    }

}

extension View {

    func textFieldAlert(isShowing: Binding<Bool>,
                        action: @escaping (String) -> (),
                        title: String) -> some View {
        TextFieldAlert(isShowing: isShowing,
                       action: action,
                       presenting: self,
                       title: title)
    }

}

struct TaskEditorView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        entity: TaskData.entity(),
        sortDescriptors: [
            NSSortDescriptor(
                keyPath: \TaskData.order,
                ascending: true
            )
    ]) var taskDataList: FetchedResults<TaskData>
    
    let taskId: Int
    
    @State private var taskData: TaskData
    @State private var newName: String
    @State private var newDuration: RelativeTime
    @State private var isShowingAlert = false
    
    init() {
        self.taskData = self.taskDataList[self.taskId]
        self.newName = self.taskData.name
        self.newDuration = self.taskData.duration
    }
    
    var body: some View {
        VStack {
            TextField(self.newName,
                      text: self.$newName)
            Spacer().frame(height: 30)
            TimePickerRelativeView(time: self.$newDuration)
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
}

struct TaskEditorView_Previewer: View {
    @State var taskData: TaskData
    
    var body: some View {
        TaskEditorView(taskData: self.$taskData)
    }
}

struct TaskEditorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TaskEditorView_Previewer(
                taskData: alarmDataList[0].taskList[1]
            )
        }
    }
}
