//
//  TaskRowView.swift
//  Routines
//
//  Created by PEACH,RYAN (K-Atlanta,ex1) on 4/12/20.
//  Copyright © 2020 Peach. All rights reserved.
//

import SwiftUI

struct TaskRowView: View {
    var taskData: TaskData
    
    var body: some View {
        HStack{
            Text(self.taskData.name)
            Spacer()
            Text(self.taskData.duration.string())
        }
    }
}

struct TaskRowView_Previews: PreviewProvider {
    static var previews: some View {
        TaskRowView(taskData: alarmData[0].taskList[0])
    }
}
