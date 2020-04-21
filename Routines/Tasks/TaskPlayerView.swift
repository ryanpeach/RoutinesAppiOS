//
//  TaskDetailView.swift
//  Routines
//
//  Created by PEACH,RYAN (K-Atlanta,ex1) on 4/12/20.
//  Copyright © 2020 Peach. All rights reserved.
//

import SwiftUI

struct CountdownTimer: View {
    let taskData: TaskData?
    @Binding var durationSoFar: TimeInterval
    
    var body: some View {
        let this = RelativeTime.fromSeconds(seconds: ((taskData?.duration.timeInterval ?? 0)-durationSoFar))
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
    @State var taskIdx: Int = 0
    
    // For the timer
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var taskData: TaskData?
    @State var isPlay: Bool = true
    @State var done: Bool = true
    @State var startTime: Date?
    @State var lastTime: Date = Date()
    @State var durationBeforePause: TimeInterval = 0
    @State var durationSoFar: TimeInterval = 0
    @State var showingAlert: Bool = false
    
    // These update taskData
    @State var taskLastDuration: [TimeInterval?] = []
    @State var taskDone: [Bool?] = []
    @State var taskLastEdited: [Date?] = []
    @State var taskNotificationId: [String?] = []
    
    var doneCriteria: Bool {
        guard let td = self.taskData else {
            print("No Task Data")
            return false
        }
        let stdl = td.subTaskDataList
        return stdl.count == 0 || stdl.allSatisfy({$0.done})
    }
    
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
                    ForEach(self.taskData?.subTaskDataList ?? [], id: \.id) { sub_td in
                        HStack {
                            SubTaskCheckbox(
                                subTaskData: sub_td
                            )
                            Text(sub_td.name)
                        }
                    }
                }
                
                Spacer().frame(height: DEFAULT_HEIGHT_SPACING)
                HStack {
                    Spacer()
                    Button(action: {
                        if self.doneCriteria {
                            self.taskLastDuration[self.taskIdx] = self.durationSoFar
                            self.taskDone[self.taskIdx] = true
                            self.taskLastEdited[self.taskIdx] = Date()
                            self.next()
                        } else {
                            self.showingAlert = true
                        }
                    }) {
                        Image(systemName: "checkmark.circle")
                            .resizable()
                            .frame(width: 100.0, height: 100.0)
                            // .foregroundColor(self.doneCriteria ? Color.blue : Color.gray) TODO: Doesn't work...
                    }
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("Not Done Yet!"),
                              message: Text("You can only click the checkmark when all tasks are done. If you want to skip, use the forward skip button below it instead."), dismissButton: .default(Text("I'm going to finish!")))
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
                    60*60+(self.taskData!.duration_),
                    self.startTime!.distance(to: self.lastTime) + self.durationBeforePause
                )
            }
        }
        .onAppear {
            self.showingAlert = false
            let tdl = self.alarmData.taskDataList
            for td in tdl {
                // Delete Notifications when you start the player
                if td.notificationId != nil {
                    LocalNotificationManager.deleteNotification(
                        id: td.notificationId!
                    )
                }
                self.taskLastDuration.append(nil)
                self.taskDone.append(nil)
                self.taskLastEdited.append(nil)
                self.taskNotificationId.append(nil)
            }
            if self.taskIdx < tdl.count {
                self.taskData = tdl[self.taskIdx]
                self.done = false
                self.isPlay = true
            }
        }
        .onDisappear() {
            self.done = true
            self.isPlay = false
            let tdl = self.alarmData.taskDataList
            for idx in tdl.indices {
                tdl[idx].lastDuration_ = self.taskLastDuration[idx] ?? tdl[idx].lastDuration_
                tdl[idx].done = self.taskDone[idx] ?? tdl[idx].done
                tdl[idx].lastEdited = self.taskLastEdited[idx] ?? tdl[idx].lastEdited
                // Let's actually delete notifications
                if tdl[idx].notificationId != nil {
                    LocalNotificationManager.deleteNotification(
                        id: tdl[idx].notificationId!
                    )
                }
                if self.taskNotificationId[idx] != nil {
                    LocalNotificationManager.deleteNotification(
                        id: self.taskNotificationId[idx]!
                    )
                }
            }
            self.taskLastDuration = []
            self.taskDone = []
            self.taskLastEdited = []
            self.taskNotificationId = []
        }
        .navigationBarTitle(Text(self.done ? "" : self.taskData!.name))
    }
    
    func deleteNotification() {
        if !self.done {
            if self.taskNotificationId[self.taskIdx] != nil {
                LocalNotificationManager.deleteNotification(
                    id: self.taskNotificationId[self.taskIdx]!
                )
            }
        }
    }
    
    func scheduleNotification() {
        LocalNotificationManager.requestPermission()
        if !self.done {
            self.deleteNotification()
            let time = (self.taskData!.duration.timeInterval-self.durationSoFar)
            if time > 0 {
                self.taskNotificationId[self.taskIdx] = LocalNotificationManager.scheduleNotificationTimeInterval(
                    time: time,
                    title: "Timer Done: \(self.taskData!.name)",
                    body: "Get on with your day!"
                )
            }
        }
    }
    
    func previous() {
        let tdl = self.alarmData.taskDataList
        let cnt = tdl.count
        if self.taskIdx > 0 {
            self.deleteNotification()
            self.taskIdx -= 1
            if self.taskIdx < cnt {
                self.done = false
            }
            self.durationSoFar = 0
            self.startTime = Date()
            self.lastTime = Date()
            self.scheduleNotification()
            self.alarmData.objectWillChange.send()
            if !self.done {
                self.taskData = tdl[self.taskIdx]
            }
        }
    }
    
    func next() {
        let tdl = self.alarmData.taskDataList
        let cnt = tdl.count
        if self.taskIdx < cnt {
            self.deleteNotification()
            self.taskIdx += 1
            if self.taskIdx == cnt {
                self.done = true
            }
            self.durationSoFar = 0
            self.startTime = Date()
            self.lastTime = Date()
            self.scheduleNotification()
            self.alarmData.objectWillChange.send()
            if !self.done {
                self.taskData = tdl[self.taskIdx]
            }
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
        taskData.order = 0
        alarmData.addToTaskData(taskData)
        return TaskDetailView_Previewer(
            alarmData: alarmData
        )
    }
}
