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
    
    var taskDataList: [TaskData] {
        return self.alarmData.taskDataList
    }
    
    var taskData: TaskData {
        return self.taskDataList[self.taskIdx]
    }
    
    var subTaskDataList: [SubTaskData] {
        var out: [SubTaskData] = []
        for sub_td in self.taskData.subTaskDataList {
            out.append(sub_td)
        }
        return out
    }
    
    @ObservedObject var alarmData: AlarmData
    @State var taskIdx: Int = 0
    
    // For the timer
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var isPlay: Bool = true
    @State var done: Bool = false
    @State var startTime: Date?
    @State var lastTime: Date = Date()
    @State var durationBeforePause: TimeInterval = 0
    @State var durationSoFar: TimeInterval = 0
    
    var body: some View {
        VStack {
            if !self.done {
                Spacer().frame(height: DEFAULT_HEIGHT_SPACING)
                CountdownTimer(
                    taskData: self.taskData,
                    durationSoFar: self.$durationSoFar
                ).font(Font.largeTitle)
                Spacer().frame(height: DEFAULT_HEIGHT_SPACING)
                List {
                    ForEach(self.subTaskDataList, id: \.id) { sub_td in
                        HStack {
                            SubTaskCheckbox(
                                subTaskData: sub_td
                            )
                            Text(sub_td.name)
                        }
                    }
                }
                .navigationBarTitle(Text(taskData.name))
                Spacer().frame(height: DEFAULT_HEIGHT_SPACING)
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation {
                            if self.subTaskDataList.count == 0 || self.subTaskDataList.allSatisfy({$0.done}) {
                                self.taskData.lastDuration_ = self.durationSoFar
                                self.taskData.done = true
                                self.taskData.lastEdited = Date()
                                self.next()
                            }
                        }
                    }) {
                        if self.subTaskDataList.count == 0 || self.subTaskDataList.allSatisfy({$0.done}) {
                            Image(systemName: "checkmark.circle")
                                .resizable()
                                .frame(width: 100.0, height: 100.0)
                        } else {
                            Image(systemName: "checkmark.circle")
                                .resizable()
                                .frame(width: 100.0, height: 100.0)
                                .foregroundColor(Color.gray)
                        }
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
                if !self.done {
                    PlayPause(
                        isPlay: self.$isPlay,
                        afterAction: {
                            if !self.isPlay {
                                self.durationBeforePause = self.durationSoFar
                                self.deleteNotification()
                            } else {
                                self.startTime = Date()
                                self.scheduleNotification()
                            }
                        }
                    )
                    Spacer()
                    Button(action: {self.next()}) {
                        Image(systemName: "forward")
                    }
                    Spacer()
                }
            }
        }
        .onReceive(timer) { input in
            if self.isPlay && !self.done {
                self.lastTime = Date()
                if self.startTime == nil {
                    self.startTime = Date()
                }
                self.durationSoFar = min(
                    60*60+(self.taskDataList[self.taskIdx].duration_),
                    self.startTime!.distance(to: self.lastTime) + self.durationBeforePause
                )
            }
        }
    }
    
    func deleteNotification() {
        if !self.done {
            if self.taskData.notificationId != nil {
                LocalNotificationManager.deleteNotification(
                    id: self.taskData.notificationId!
                )
            }
        }
    }
    
    func scheduleNotification() {
        LocalNotificationManager.requestPermission()
        if !self.done {
            self.deleteNotification()
            let time = (self.taskData.duration.timeInterval-self.durationSoFar)
            if time > 0 {
                self.taskData.notificationId = LocalNotificationManager.scheduleNotificationTimeInterval(
                    time: time,
                    title: "Timer Done: \(self.taskData.name)",
                    body: "Get on with your day!"
                )
            }
        }
    }
    
    func previous() {
        if self.taskIdx > 0 {
            self.deleteNotification()
            self.done = false
            self.taskIdx -= 1
            self.durationSoFar = 0
            self.startTime = Date()
            self.lastTime = Date()
            self.scheduleNotification()
            self.alarmData.objectWillChange.send()
        }
    }
    
    func next() {
        if self.taskIdx < self.taskDataList.count {
            self.deleteNotification()
            if self.taskIdx == self.taskDataList.count - 1 {
                self.done = true
            } else {
                self.taskIdx += 1
            }
            self.durationSoFar = 0
            self.startTime = Date()
            self.lastTime = Date()
            self.scheduleNotification()
            self.alarmData.objectWillChange.send()
        }
    }
}

struct TaskDetailView_Previewer: View {
    @ObservedObject var alarmData: AlarmData
    @State var taskPlayerIdx: Int = 0
    var body: some View {
        TaskPlayerView(
            alarmData: self.alarmData,
            taskIdx: self.taskPlayerIdx
        )
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
        return TaskDetailView_Previewer(
            alarmData: alarmData
        )
    }
}
