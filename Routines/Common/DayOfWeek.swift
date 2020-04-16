//
//  Data.swift
//  Routines
//
//  Created by PEACH,RYAN on 4/12/20.
//  Copyright © 2020 Peach. All rights reserved.
//

import SwiftUI
import Foundation
import Combine

enum DayOfWeek {
    case Monday
    case Tuesday
    case Wednesday
    case Thursday
    case Friday
    case Saturday
    case Sunday
}

// REF: https://www.geeksforgeeks.org/check-whether-k-th-bit-set-not/
func daysOfWeekToInt(daysOfWeek: [DayOfWeek]) -> Int16 {
    var out: Int16 = 0
    if daysOfWeek.contains(DayOfWeek.Monday)    {out += (Int16(1) << 0)}
    if daysOfWeek.contains(DayOfWeek.Tuesday)   {out += (Int16(1) << 1)}
    if daysOfWeek.contains(DayOfWeek.Wednesday) {out += (Int16(1) << 2)}
    if daysOfWeek.contains(DayOfWeek.Thursday)  {out += (Int16(1) << 3)}
    if daysOfWeek.contains(DayOfWeek.Friday)    {out += (Int16(1) << 4)}
    if daysOfWeek.contains(DayOfWeek.Saturday)  {out += (Int16(1) << 5)}
    if daysOfWeek.contains(DayOfWeek.Sunday)    {out += (Int16(1) << 6)}
    return out
}

func daysOfWeekFromInt(daysOfWeek: Int16) -> [DayOfWeek] {
    var out: [DayOfWeek] = []
    if (daysOfWeek & (Int16(1) << 0)) != 0 {out.append(DayOfWeek.Monday)}
    if (daysOfWeek & (Int16(1) << 1)) != 0 {out.append(DayOfWeek.Tuesday)}
    if (daysOfWeek & (Int16(1) << 2)) != 0 {out.append(DayOfWeek.Wednesday)}
    if (daysOfWeek & (Int16(1) << 3)) != 0 {out.append(DayOfWeek.Thursday)}
    if (daysOfWeek & (Int16(1) << 4)) != 0 {out.append(DayOfWeek.Friday)}
    if (daysOfWeek & (Int16(1) << 5)) != 0 {out.append(DayOfWeek.Saturday)}
    if (daysOfWeek & (Int16(1) << 6)) != 0 {out.append(DayOfWeek.Sunday)}
    return out
}

struct DayOfWeekButton: View {
    let text: String
    let action: () -> ()
    @Binding var isActive: Bool
    var body: some View {
        Button(action: {
            self.isActive.toggle()
            self.action()
        }) {
            Text(text).foregroundColor(
                self.isActive ? Color.blue : Color.black
            )
        }
    }
}

struct DaysOfWeekPicker: View {
    @Binding var daysOfWeek: [DayOfWeek]
    @State var hasMonday: Bool = true
    @State var hasTuesday: Bool = true
    @State var hasWednesday: Bool = true
    @State var hasThursday: Bool = true
    @State var hasFriday: Bool = true
    @State var hasSaturday: Bool = true
    @State var hasSunday: Bool = true
    var body: some View {
        HStack {
            DayOfWeekButton(
                text: "Sun",
                action: getDaysOfWeek,
                isActive: self.$hasSunday
            )
            DayOfWeekButton(
                text: "Mon",
                action: getDaysOfWeek,
                isActive: self.$hasMonday
            )
            DayOfWeekButton(
                text: "Tue",
                action: getDaysOfWeek,
                isActive: self.$hasTuesday
            )
            DayOfWeekButton(
                text: "Wed",
                action: getDaysOfWeek,
                isActive: self.$hasWednesday
            )
            DayOfWeekButton(
                text: "Thu",
                action: getDaysOfWeek,
                isActive: self.$hasThursday
            )
            DayOfWeekButton(
                text: "Fri",
                action: getDaysOfWeek,
                isActive: self.$hasFriday
            )
            DayOfWeekButton(
                text: "Sat",
                action: getDaysOfWeek,
                isActive: self.$hasSaturday
            )
        }
    }
    
    func getDaysOfWeek() {
        var out: [DayOfWeek] = []
        if hasMonday {out.append(DayOfWeek.Monday)}
        if hasTuesday {out.append(DayOfWeek.Tuesday)}
        if hasWednesday {out.append(DayOfWeek.Wednesday)}
        if hasThursday {out.append(DayOfWeek.Thursday)}
        if hasFriday {out.append(DayOfWeek.Friday)}
        if hasSaturday {out.append(DayOfWeek.Saturday)}
        if hasSunday {out.append(DayOfWeek.Sunday)}
        self.daysOfWeek = out
    }
}

struct DaysOfWeekView: View {
    var daysOfWeek: Set<DayOfWeek>
    
    var body: some View {
        HStack {
            // I did it this way so you can apply style
            // changes to each of the days of the week
            // And to preserver proper ordering and string
            // conversion
            if (self.daysOfWeek.contains(DayOfWeek.Sunday)) {
                Text("Sun")
            }
            if (self.daysOfWeek.contains(DayOfWeek.Monday)) {
                Text("Mon")
            }
            if (self.daysOfWeek.contains(DayOfWeek.Tuesday)) {
                Text("Tue")
            }
            if (self.daysOfWeek.contains(DayOfWeek.Wednesday)) {
                Text("Wed")
            }
            if (self.daysOfWeek.contains(DayOfWeek.Thursday)) {
                Text("Thu")
            }
            if (self.daysOfWeek.contains(DayOfWeek.Friday)) {
                Text("Fri")
            }
            if (self.daysOfWeek.contains(DayOfWeek.Saturday)) {
                Text("Sat")
            }
        }
    }
}


struct DayOfWeek_Previewer: View {
    @State var daysOfWeek: [DayOfWeek] = []
    var body: some View {
        VStack {
            DaysOfWeekPicker(daysOfWeek: $daysOfWeek)
            DaysOfWeekView(daysOfWeek: [
                DayOfWeek.Sunday,
                DayOfWeek.Monday,
                DayOfWeek.Tuesday,
                DayOfWeek.Wednesday,
                DayOfWeek.Thursday,
                DayOfWeek.Friday,
                DayOfWeek.Saturday
            ])
        }
    }
}


struct DayOfWeek_Previews: PreviewProvider {
    static var previews: some View {
        DayOfWeek_Previewer()
    }
}
