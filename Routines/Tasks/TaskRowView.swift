//
//  TaskRowView.swift
//  Routines
//
//  Created by PEACH,RYAN (K-Atlanta,ex1) on 4/12/20.
//  Copyright © 2020 Peach. All rights reserved.
//

import SwiftUI
import CoreData

struct DurationView: View {
    @ObservedObject var taskData: TaskData
    
    var diff: RelativeTime {
        return RelativeTime.fromSeconds(seconds: self.taskData.duration_ - self.taskData.lastDuration_)
    }
    
    var body: some View {
        HStack {
            if self.taskData.lastDuration_ > 0 {
                if diff.timeInterval <= 0 {
                    Text("+"+diff.stringMS()).foregroundColor(Color.red)
                } else {
                    Text("-"+diff.stringMS()).foregroundColor(Color.green)
                }
            } else {
                Text("")
            }
        }
    }
}

struct TaskRowForeground: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @ObservedObject var taskData: TaskData
    
    var body: some View {
        HStack {
            Spacer().frame(width: 5)
            TaskCheckbox(
                taskData: self.taskData
            )
            Spacer().frame(width: 10)
            Text(self.taskData.name)
            Spacer()
            Text(self.taskData.duration.stringMS())
            Spacer().frame(width: 5)
            DurationView(taskData: self.taskData)
            Spacer().frame(width: 5)
        }
    }
}

struct TaskRowView: View {
    @Environment(\.managedObjectContext) private var managedObjectContext

    @Binding var tag: UUID?
    @ObservedObject var taskData: TaskData
    @Binding var taskPlayerIdx: Int
    
    @State private var inEditing: Bool = false
    
    var body: some View {
        ZStack {
            TaskRowForeground(taskData: self.taskData)
                .contextMenu {
                    Button(action: {
                        self.taskPlayerIdx = self.taskData.alarmData.taskDataList.firstIndex(of: self.taskData) ?? 0
                    }, label: {
                        HStack {
                            Text("Start From Here")
                            Image(systemName: "play.circle")
                        }
                    })
                    Button(action: {
                        self.inEditing = true
                    }, label: {
                        HStack {
                            Text("Edit")
                            Image(systemName: "square.and.pencil")
                        }
                    })
                    Button(action: {
                        self.managedObjectContext.delete(self.taskData)
                    }, label: {
                        HStack {
                            Text("Remove")
                            Image(systemName: "trash")
                        }.foregroundColor(Color.red)
                    })
                }
            
            // This Navigation Link uses the "isActive" method of creating a link to TaskEditor,
            // Based on the Edit button in the above context menu.
            // Since it comes right back to this view, this works well.
            NavigationLink(
                destination: TaskEditorView(
                    inEditing: self.$inEditing,
                    taskData: self.taskData
                ),
                isActive: self.$inEditing
            ) { EmptyView() }
        }
    }
}

struct TaskRowView_Previewer: View {
    @ObservedObject var taskData: TaskData
    @State var tag: UUID?
    @State var taskPlayerIdx: Int = 0
    var body: some View {
        TaskRowView(
            tag: self.$tag,
            taskData: self.taskData,
            taskPlayerIdx: self.$taskPlayerIdx
        )
    }
}
struct TaskRowView_Previews: PreviewProvider {
    
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    static var previews: some View {
        let taskData = TaskData(context: moc)
        taskData.id = UUID()
        taskData.name = "Get out of bed."
        taskData.lastDuration_ = 1
        return TaskRowView_Previewer(
            taskData: taskData,
            tag: taskData.id
        )
    }
}
