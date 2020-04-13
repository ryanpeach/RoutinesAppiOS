//
//  TaskRowView.swift
//  Routines
//
//  Created by PEACH,RYAN (K-Atlanta,ex1) on 4/12/20.
//  Copyright © 2020 Peach. All rights reserved.
//

import SwiftUI

struct TaskRowView: View {
    let alarmId: UUID
    let taskId: UUID
    
    @Binding private var taskData: TaskData
    
    var body: some View {
        NavigationLink(destination: TaskDetailView(taskData: self.$taskData)) {
            HStack{
                Text(self.taskData.name)
                Spacer()
                Text(self.taskData.duration.stringMS())
            }
        }
    }
}

struct TaskRowView_Previewer: View {
    @State var taskData: TaskData
    var body: some View {
        TaskRowView(taskData: self.$taskData)
    }
}

struct TaskRowView_Previews: PreviewProvider {
    static var previews: some View {
        TaskRowView_Previewer(taskData: alarmDataList[0].taskList[1]).previewLayout(.fixed(width: 500, height: 100))
    }
}
