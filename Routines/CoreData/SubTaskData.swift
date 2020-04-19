//
//  SubTaskData.swift
//  Routines
//
//  Created by PEACH,RYAN (K-Atlanta,ex1) on 4/18/20.
//  Copyright © 2020 Peach. All rights reserved.
//

import Foundation
import CoreData

extension SubTaskData {
    func resetDone() {
        if self.lastEdited == nil {
            self.done = false
        } else {
            // This is now
            let todayComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
            
            // This is the reset time
            let hour = SettingsBundleHelper.getResetHour()
            let resetTimeToday = DateComponents(
                year: todayComponents.year,
                month: todayComponents.month,
                day: todayComponents.day,
                hour: hour,
                minute: 0,
                second: 0
            )
            
            // The main logic
            let isAfterResetTime = Date() > Calendar.current.date(from: resetTimeToday)!
            let hasBeenEdited = self.lastEdited! > Calendar.current.date(from: resetTimeToday)!
            
            if isAfterResetTime && (!hasBeenEdited) {
                self.done = false
            }
        }
    }
    
    func delete(moc: NSManagedObjectContext) {
        moc.delete(self)
    }
}
