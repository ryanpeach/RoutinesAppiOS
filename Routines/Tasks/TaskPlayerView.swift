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
    var fetchRequest: FetchRequest<TaskData>
    var taskDataList: FetchedResults<TaskData> {
        fetchRequest.wrappedValue
    }
    @FetchRequest(
        entity: SubTaskData.entity(),
        sortDescriptors: [
            NSSortDescriptor(
                keyPath: \SubTaskData.order,
                ascending: true
            )
    ]) var subTaskDataListUnfiltered: FetchedResults<SubTaskData>
    
    var subTaskDataList: [SubTaskData] {
        if self.taskData == nil {
            return []
        }
        var out: [SubTaskData] = []
        for sub_td in subTaskDataListUnfiltered {
            if sub_td.taskData.id == self.taskData!.id {
                out.append(sub_td)
            }
        }
        return out
    }
    
    @Binding var taskIdx: Int
    
    // For the timer
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var isPlay: Bool = true
    @State var startTime: Date?
    @State var lastTime: Date = Date()
    @State var durationBeforePause: TimeInterval = 0
    @State var durationSoFar: TimeInterval = 0

    var taskData: TaskData? {
        if taskDataList.count == 0 {
            return nil
        } else {
            return self.taskDataList[self.taskIdx]
        }
    }
    
    init(alarmData: AlarmData, taskIdx: Binding<Int>) {
        self._taskIdx = taskIdx
        fetchRequest = FetchRequest<TaskData>(
            entity: TaskData.entity(),
            sortDescriptors: [
                NSSortDescriptor(
                    keyPath: \TaskData.order,
                    ascending: true
                )
            ],
            predicate: NSPredicate(
                format: "alarmData.id == %@", alarmData.id.uuidString
        ))
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
                    ForEach(self.subTaskDataList, id: \.id) { sub_td in
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
                        if self.subTaskDataList.allSatisfy({$0.done}) ?? true {
                            self.taskData!.lastDuration_ = self.durationSoFar
                            self.taskData!.done = true
                            self.taskData!.lastEdited = Date()
                            self.next()
                        }
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
            if self.isPlay {
                self.lastTime = Date()
                if self.startTime == nil {
                    self.startTime = Date()
                }
                self.durationSoFar = min(
                    60*60+(self.taskData?.duration_ ?? 0),
                    self.startTime!.distance(to: self.lastTime) + self.durationBeforePause
                )
            }
        }
    }
    
    func deleteNotification() {
        if taskData != nil {
            if self.taskData!.notificationId != nil {
                LocalNotificationManager.deleteNotification(
                    id: self.taskData!.notificationId!
                )
            }
        }
    }
    
    func scheduleNotification() {
        LocalNotificationManager.requestPermission()
        if taskData != nil {
            self.deleteNotification()
            let time = (self.taskData!.duration.timeInterval-self.durationSoFar)
            if time > 0 {
                self.taskData!.notificationId = LocalNotificationManager.scheduleNotificationTimeInterval(
                    time: time,
                    title: "Timer Done: \(self.taskData!.name)",
                    body: "Get on with your day!"
                )
            }
        }
    }
    
    func previous() {
        if self.taskIdx > 0 {
            self.deleteNotification()
            self.taskIdx -= 1
            self.durationSoFar = 0
            self.startTime = Date()
            self.lastTime = Date()
            self.scheduleNotification()
        }
    }
    
    func next() {
        if self.taskIdx < self.taskDataList.count {
            self.deleteNotification()
            self.taskIdx += 1
            self.durationSoFar = 0
            self.startTime = Date()
            self.lastTime = Date()
            self.scheduleNotification()
        }
    }
}

struct TaskDetailView_Previewer: View {
    @ObservedObject var alarmData: AlarmData
    @State var taskPlayerIdx: Int = 0
    var body: some View {
        TaskPlayerView(
            alarmData: self.alarmData,
            taskIdx: self.$taskPlayerIdx
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
