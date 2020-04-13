//
//  AlarmData+CoreDataClass.swift
//  Routines
//
//  Created by PEACH,RYAN (K-Atlanta,ex1) on 4/13/20.
//  Copyright © 2020 Peach. All rights reserved.
//
//

import Foundation
import CoreData

@objc(AlarmData)
public class AlarmData: NSManagedObject {
    var time: RelativeTime {
        RelativeTime.fromSeconds(seconds: TimeInterval(self.time_))
    }
    
    var daysOfWeek: [DayOfWeek] {
        daysOfWeekFromInt(daysOfWeek: self.daysOfWeek_)
    }
}
