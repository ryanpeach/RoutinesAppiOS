//
//  TaskData+CoreDataClass.swift
//  Routines
//
//  Created by PEACH,RYAN (K-Atlanta,ex1) on 4/13/20.
//  Copyright © 2020 Peach. All rights reserved.
//
//

import Foundation
import CoreData

extension TaskData {
    var duration: RelativeTime {
        RelativeTime.fromSeconds(seconds: TimeInterval(self.duration_))
    }
    
    var subTaskDataList: [SubTaskData] {
        var subTaskDataList: [SubTaskData] = []
        for sub_td in self.subTaskData ?? [] {
            subTaskDataList.append((sub_td as! SubTaskData))
        }
        return subTaskDataList.sorted(by: { $0.order < $1.order })
    }
}

