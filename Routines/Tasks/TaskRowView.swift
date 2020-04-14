//
//  TaskRowView.swift
//  Routines
//
//  Created by PEACH,RYAN (K-Atlanta,ex1) on 4/12/20.
//  Copyright © 2020 Peach. All rights reserved.
//

import SwiftUI

struct TaskRowView: View {
    let taskData: TaskData
    
    var body: some View {
        // NavigationLink(destination: TaskDetailView(taskData: self.taskData)) {
            HStack{
                Text(self.taskData.name!)
                Spacer()
                Text(self.taskData.duration.stringMS())
            }
        // }
    }
}
