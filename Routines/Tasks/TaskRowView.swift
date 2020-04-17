//
//  TaskRowView.swift
//  Routines
//
//  Created by PEACH,RYAN (K-Atlanta,ex1) on 4/12/20.
//  Copyright © 2020 Peach. All rights reserved.
//

import SwiftUI
import CoreData

struct TaskRowView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @ObservedObject var taskData: TaskData
    
    var body: some View {
        HStack {
            Spacer().frame(width: 5)
            TaskCheckbox(
                taskData: self.taskData,
                threshold: self.taskData.alarmData.time.today
            )
            Spacer().frame(width: 10)
            Text(self.taskData.name)
            Spacer()
            Text(self.taskData.duration.stringMS())
            Spacer().frame(width: 5)
        }
    }
}

struct TaskRowView_Previewer: View {
    var taskData: TaskData
    var body: some View {
        TaskRowView(taskData: self.taskData)
    }
}
struct TaskRowView_Previews: PreviewProvider {
    
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    static var previews: some View {
        let taskData = TaskData(context: moc)
        taskData.id = UUID()
        taskData.name = "Get out of bed."
        return TaskRowView_Previewer(taskData: taskData)
    }
}
