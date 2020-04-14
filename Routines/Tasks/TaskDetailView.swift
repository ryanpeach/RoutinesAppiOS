//
//  TaskDetailView.swift
//  Routines
//
//  Created by PEACH,RYAN (K-Atlanta,ex1) on 4/12/20.
//  Copyright © 2020 Peach. All rights reserved.
//

import SwiftUI

struct TaskDetailView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @ObservedObject var taskData: TaskData
    
    var body: some View {
        VStack {
            Text(taskData.duration.stringMS())
            List (taskData.subTaskDataList, id: \.id) { sub_td in
                HStack {
                    Button(action: {}) {
                        Image(systemName: "circle")
                    }
                    Text(sub_td.name)
                }
            }
            .navigationBarTitle(Text(self.taskData.name))
            .navigationBarItems(
                trailing:
                NavigationLink(destination:
                    TaskEditorView(taskData: taskData)) {
                    Text("Edit")
                }
            )
            HStack {
                Spacer()
                Button(action: {}) {
                    Image(systemName: "checkmark.circle")
                        .resizable()
                        .frame(width: 100.0, height: 100.0)
                }
                Spacer()
            }
            Spacer().frame(height: 30)
            HStack {
                Spacer()
                Button(action: {}) {
                    Image(systemName: "backward")
                }
                Spacer()
                Button(action: {}) {
                    Image(systemName: "pause")
                }
                Spacer()
                Button(action: {}) {
                    Image(systemName: "forward")
                }
                Spacer()
            }
        }
    }
}

struct TaskDetailView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
