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
    let alarmId: UUID
    let taskId: UUID
    
    @Binding private var taskData: TaskData
    @State private var isShowingAlert = false
    
    var body: some View {
        VStack {
            TextField(self.taskData.name, text: self.taskData.$name)
            Spacer().frame(height: 30)
            TimePickerRelativeView(time: self.$taskData.duration)
            Spacer().frame(height: 30)
            Text("Subtasks:")
            Spacer().frame(height: 15)
            List {
                ForEach(self.taskData.subtasks) { sub_td in
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
        self.taskData.subtasks.remove(atOffsets: offsets)
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
