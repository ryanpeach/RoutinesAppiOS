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

@objc(TaskData)
public class TaskData: NSManagedObject {
    var duration: RelativeTime {
        RelativeTime.fromSeconds(seconds: TimeInterval(self.duration_))
    }
}
