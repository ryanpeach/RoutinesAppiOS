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
                Text(sub_td.name)
            }
            .navigationBarTitle(Text(self.taskData.name))
            .navigationBarItems(
                trailing:
                NavigationLink(destination: TaskEditorView(taskData: taskData)) {
                    Text("Edit")
                }
            )
        }
    }
}

struct TaskDetailView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
