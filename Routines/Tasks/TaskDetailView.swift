//
//  TaskDetailView.swift
//  Routines
//
//  Created by PEACH,RYAN (K-Atlanta,ex1) on 4/12/20.
//  Copyright © 2020 Peach. All rights reserved.
//

import SwiftUI

struct TaskPlayerView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @ObservedObject var taskData: TaskData
    
    var body: some View {
        VStack {
            Text(taskData.duration.stringMS()).font(Font.title)
            List (taskData.subTaskDataList, id: \.id) { sub_td in
                HStack {
                    Checkbox(action: {})
                    Text(sub_td.name)
                }
            }
            .navigationBarTitle(Text(self.taskData.name))
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
                PlayPause()
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
        let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let alarmData = AlarmData(context: moc)
        alarmData.id = UUID()
        alarmData.name = "Morning"
        let taskData = TaskData(context: moc)
        taskData.id = UUID()
        taskData.name = "Get out of bed."
        alarmData.addToTaskData(taskData)
        return TaskPlayerView(taskData: taskData)
    }
}
