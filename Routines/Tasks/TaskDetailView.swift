//
//  TaskDetailView.swift
//  Routines
//
//  Created by PEACH,RYAN (K-Atlanta,ex1) on 4/12/20.
//  Copyright © 2020 Peach. All rights reserved.
//

import SwiftUI

struct TaskDetailView: View {
    var taskData: TaskData
    
    var body: some View {
        List(taskData.subtasks) { sub_td in
            Text(sub_td.name)
        }
        .navigationBarTitle(Text(self.taskData.name))
    }
}

struct TaskDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TaskDetailView(
            taskData: alarmData[0].taskList[0]
        )
    }
}
