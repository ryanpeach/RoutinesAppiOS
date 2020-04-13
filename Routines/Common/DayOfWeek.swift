//
//  Data.swift
//  Routines
//
//  Created by PEACH,RYAN on 4/12/20.
//  Copyright © 2020 Peach. All rights reserved.
//

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
