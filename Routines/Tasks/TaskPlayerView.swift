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
    
    @ObservedObject var alarmData: AlarmData
    
    @State private var taskIndex: Int = 0
   
    var taskData: TaskData? {
        if self.taskIndex >= self.alarmData.taskDataList.count {
            return nil
        } else {
            return self.alarmData.taskDataList[self.taskIndex]
        }
    }
    
    var subTaskList: [SubTaskData] {
        return self.taskData?.subTaskDataList ?? []
    }
    
    var body: some View {
        VStack {
            Text((taskData?.duration ?? RelativeTime.fromSeconds(seconds: 0)).stringMS()).font(Font.title)
            List {
                ForEach(subTaskList) { sub_td in
                    HStack {
                        Checkbox(
                            action: {}
                        )
                        Text(sub_td.name)
                    }
                }
            }
            .navigationBarTitle(Text(taskData?.name ?? "Done!"))
            HStack {
                Spacer()
                Button(action: {self.next()}) {
                    Image(systemName: "checkmark.circle")
                        .resizable()
                        .frame(width: 100.0, height: 100.0)
                }
                Spacer()
            }
            Spacer().frame(height: 30)
            HStack {
                Spacer()
                Button(action: {self.previous()}) {
                    Image(systemName: "backward")
                }
                Spacer()
                PlayPause()
                Spacer()
                Button(action: {self.next()}) {
                    Image(systemName: "forward")
                }
                Spacer()
            }
        }
    }
    
    func previous() {
        if self.taskIndex > 0 {
            self.taskIndex -= 1
        }
    }
    
    func next() {
        if self.taskIndex < self.alarmData.taskDataList.count {
            self.taskIndex += 1
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
        return TaskPlayerView(alarmData: alarmData)
    }
}