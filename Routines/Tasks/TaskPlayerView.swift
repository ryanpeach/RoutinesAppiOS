//
//  TaskDetailView.swift
//  Routines
//
//  Created by PEACH,RYAN (K-Atlanta,ex1) on 4/12/20.
//  Copyright © 2020 Peach. All rights reserved.
//

import SwiftUI

struct CountdownTimer: View {
    @ObservedObject var taskData: TaskData
    @Binding var durationSoFar: TimeInterval
    
    var body: some View {
        let this = RelativeTime.fromSeconds(seconds: (taskData.duration.timeInterval-durationSoFar))
        if this.timeInterval < 0 {
            return Text("-"+this.stringMS()).foregroundColor(Color.red)
        } else {
            return Text(this.stringMS())
        }
    }
}


struct TaskPlayerView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @ObservedObject var alarmData: AlarmData
    
    @State var taskIndex: Int = 0
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State var isPlay: Bool = true
    @State var durationSoFar: TimeInterval = 0

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
            if taskData != nil {
                Spacer().frame(height: DEFAULT_HEIGHT_SPACING)
                CountdownTimer(
                    taskData: self.taskData!,
                    durationSoFar: self.$durationSoFar
                ).font(Font.largeTitle)
                Spacer().frame(height: DEFAULT_HEIGHT_SPACING)
                List {
                    ForEach(subTaskList) { sub_td in
                        HStack {
                            SubTaskCheckbox(
                                subTaskData: sub_td
                            )
                            Text(sub_td.name)
                        }
                    }
                }
                .navigationBarTitle(Text(taskData!.name))
                Spacer().frame(height: DEFAULT_HEIGHT_SPACING)
                HStack {
                    Spacer()
                    Button(action: {
                        self.taskData!.lastDuration_ = self.durationSoFar
                        self.next()
                    }) {
                        Image(systemName: "checkmark.circle")
                            .resizable()
                            .frame(width: 100.0, height: 100.0)
                    }
                    Spacer()
                }
            } else {
                Spacer()
                Text("Done!").font(Font.largeTitle)
                Spacer()
            }
            Spacer().frame(height: DEFAULT_HEIGHT_SPACING)
            HStack {
                Spacer()
                Button(action: {self.previous()}) {
                    Image(systemName: "backward")
                }
                Spacer()
                if taskData != nil {
                    PlayPause(isPlay: self.$isPlay)
                    Spacer()
                    Button(action: {self.next()}) {
                        Image(systemName: "forward")
                    }
                    Spacer()
                }
            }
        }
        .onReceive(timer) { input in
            self.durationSoFar += 1
        }
    }
    
    func previous() {
        if self.taskIndex > 0 {
            self.taskIndex -= 1
            self.durationSoFar = 0
        }
    }
    
    func next() {
        if self.taskData?.subTaskDataList.allSatisfy({$0.done}) ?? true {
            if self.taskIndex < self.alarmData.taskDataList.count {
                self.taskIndex += 1
                self.durationSoFar = 0
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
        return TaskPlayerView(alarmData: alarmData)
    }
}
