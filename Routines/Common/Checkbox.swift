//
//  Checkbox.swift
//  Routines
//
//  Created by PEACH,RYAN (K-Atlanta,ex1) on 4/14/20.
//  Copyright © 2020 Peach. All rights reserved.
//

import SwiftUI

enum DoneEnum {
    case Done
    case Some
    case None
}

struct SubTaskCheckbox: View {
    @ObservedObject var subTaskData: SubTaskData
    
    /*
    init(subTaskData: SubTaskData, threshold: Date) {
        subTaskData_ = subTaskData
        if subTaskData_.lastEdited == nil {
            subTaskData_.done = false
        } else if (subTaskData_.lastEdited! < threshold) && (subTaskData_.lastEdited!.timeIntervalSinceNow > MIN_RESET_SECONDS) {
            subTaskData_.done = false
        }
    }
    */
    
    var body: some View {
        Button(action: {
            self.subTaskData.done.toggle()
            self.subTaskData.lastEdited = Date()
            self.subTaskData.objectWillChange.send()
        }) {
            Image(systemName: self.subTaskData.done ? "circle.fill" : "circle")
                .frame(width: DEFAULT_LEFT_ALIGN_SPACE, height: 30)
        }
    }
}

struct TaskCheckbox: View {
    
    @ObservedObject private var taskData_: TaskData
    
    init(taskData: TaskData, threshold: Date) {
        let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        // Reset all sub task data
        taskData_ = taskData
        for subTaskData in taskData.subTaskDataList {
            if subTaskData.lastEdited == nil {
                subTaskData.done = false
            } else if (subTaskData.lastEdited! < threshold) && (subTaskData.lastEdited!.timeIntervalSinceNow > MIN_RESET_SECONDS) {
                subTaskData.done = false
            }
            subTaskData.objectWillChange.send()
        }
        
        // Save
        do {
            try moc.save()
        } catch let error {
            print("Could not save. \(error)")
        }
        
        // taskData.objectWillChange.send()
    }
    
    var done: DoneEnum {
        if self.taskData_.subTaskDataList.allSatisfy({$0.done}) {
            return DoneEnum.Done
        } else if self.taskData_.subTaskDataList.contains(where: {$0.done}) {
            return DoneEnum.Some
        } else {
            return DoneEnum.None
        }
    }
    
    var body: some View {
        let img: Image = {
            switch self.done {
                case DoneEnum.Done:
                    return Image(systemName: "circle.fill")
                case DoneEnum.Some:
                    return Image(systemName: "circle.righthalf.fill")
                case DoneEnum.None:
                    return Image(systemName: "circle")
            }
        }()
        return img.frame(
            width: DEFAULT_LEFT_ALIGN_SPACE,
            height: 30
        )
    }
}

/*
struct Checkbox_Previewer: View {
    @State var done: Bool = false
    @State var lastEdited: Date?
    var body: some View {
        SubTaskCheckbox(
            action: {}
        )
    }
}

struct Checkbox_Previews: PreviewProvider {
    static var previews: some View {
        Checkbox_Previewer()
    }
}
*/
