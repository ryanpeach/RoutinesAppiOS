//
//  Checkbox.swift
//  Routines
//
//  Created by PEACH,RYAN (K-Atlanta,ex1) on 4/14/20.
//  Copyright © 2020 Peach. All rights reserved.
//

import SwiftUI

let MIN_RESET_SECONDS: TimeInterval = 3*60*60  // 3 hours

struct SubTaskCheckbox: View {
    var action: () -> () = {}
    
    @ObservedObject private var subTaskData_: SubTaskData
    
    init(subTaskData: SubTaskData, threshold: Date) {
        subTaskData_ = subTaskData
        if subTaskData_.lastEdited == nil {
            subTaskData_.done = false
        } else if (subTaskData_.lastEdited! < threshold) && (subTaskData_.lastEdited!.timeIntervalSinceNow > MIN_RESET_SECONDS) {
            subTaskData_.done = false
        }
    }
    
    var body: some View {
        Button(action: {
            self.subTaskData_.done.toggle()
            self.subTaskData_.lastEdited = Date()
        }) {
            Image(systemName: self.subTaskData_.done ? "circle.fill" : "circle")
                .frame(width: 30, height: 30)
        }
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
