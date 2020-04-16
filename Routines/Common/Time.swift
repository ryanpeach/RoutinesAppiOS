//
//  TimePickerView.swift
//  Routines
//
//  Created by PEACH,RYAN on 4/13/20.
//  Copyright © 2020 Peach. All rights reserved.
//

// REF: https://stackoverflow.com/questions/56567539/multi-component-picker-uipickerview-in-swiftui

import SwiftUI

struct TimePickerAbsolute: View {
    
    @Binding var currentDate: Date
    
    var body: some View {
        VStack {
            DatePicker("", selection: $currentDate, displayedComponents: .hourAndMinute)
            .labelsHidden()
        }
    }
}

struct RelativeTime: Hashable {
    var _seconds: TimeInterval
    var _minutes: Int
    var _hours: Int
    
    // Initialization Functions
    static func fromSeconds(seconds: TimeInterval) -> RelativeTime {
        RelativeTime(
            _seconds: RelativeTime.cutoffSeconds(seconds: seconds),
            _minutes: RelativeTime.cutoffMinutes(seconds: seconds),
            _hours: RelativeTime.cutoffHours(seconds: seconds)
        )
    }
    
    static func fromDayTime(hours: Int, minutes: Int, seconds: TimeInterval) -> RelativeTime {
        RelativeTime.fromSeconds(
            seconds:
                seconds +
                TimeInterval(minutes) * 60 +
                TimeInterval(hours) * 60 * 60
        )
    }
    
    // Getters
    var timeInterval: TimeInterval {
        self._seconds +
        TimeInterval(self._minutes) * 60 +
        TimeInterval(self._hours) * 60 * 60
    }
    
    // Converters
    static func cutoffHours(seconds: TimeInterval) -> Int {
        Int(seconds) / 60 / 60
    }
    
    static func cutoffMinutes(seconds: TimeInterval) -> Int {
        Int(seconds) / 60 % 60
    }
    
    static func cutoffSeconds(seconds: TimeInterval) -> TimeInterval {
        seconds.truncatingRemainder(dividingBy: 60)
    }
    
    // Strings
    func stringMS() -> String {
        String(format: "%02d", self._minutes+self._hours*60) + ":" +
            String(format: "%02d", Int(self._seconds))
    }
    
    func stringHM() -> String {
        String(format: "%02d", self._hours) + ":" +
            String(format: "%02d", self._minutes)
    }
    
    func stringHMS() -> String {
        String(format: "%02d", self._hours) + ":" +
            String(format: "%02d", self._minutes) + ":" +
            String(format: "%02d", Int(self._seconds))
    }
}


struct TimePickerRelativeView: View  {

    @Binding var time: RelativeTime
    
    var body: some View {
        VStack {
            Spacer().frame(height: DEFAULT_HEIGHT_SPACING)
            GeometryReader { geometry in
                HStack{
                    VStack{
                        Text("Hours")
                        Picker(
                            selection: self.$time._hours,
                            label: Text("Hours")
                        ) {
                            ForEach(0..<24) { i in
                                Text(String(i)).tag(i)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: geometry.size.width / CGFloat(3), height: geometry.size.height)
                        .clipped()
                    }
                    VStack{
                        Text("Minutes")
                        Picker(
                            selection: self.$time._minutes,
                            label: Text("Minutes")
                        ) {
                            ForEach(0..<60) { i in
                                Text(String(i)).tag(i)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: geometry.size.width / CGFloat(3), height: geometry.size.height)
                        .clipped()
                    }
                    VStack{
                        Text("Seconds")
                        Picker(
                            selection: self.$time._seconds,
                            label: Text("Seconds")
                        ) {
                            ForEach(0..<60) { i in
                                Text(String(i)).tag(i)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: geometry.size.width / CGFloat(3), height: geometry.size.height)
                        .clipped()
                    }
                }
            }.frame(height: 150)
            Spacer().frame(height: DEFAULT_HEIGHT_SPACING)
        }
    }
}


struct TimePickerRelativeView_Preview_View: View {
    @State var time: RelativeTime
    
    var body: some View {
        TimePickerRelativeView(time: self.$time)
    }
}
struct TimePickerRelativeView_Previews: PreviewProvider {
    static var previews: some View {
        TimePickerRelativeView_Preview_View(time:
            RelativeTime.fromDayTime(
                hours: 1,
                minutes: 30,
                seconds: 20.0
            )
        )
    }
}
