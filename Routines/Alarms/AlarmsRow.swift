//
//  AlarmsRow.swift
//  Routines
//
//  Created by PEACH,RYAN (K-Atlanta,ex1) on 4/12/20.
//  Copyright © 2020 Peach. All rights reserved.
//

import SwiftUI
import CoreData

let DRAG_LIMIT: CGFloat = 90

struct AlarmsRow: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment (\.colorScheme) var colorScheme:ColorScheme
    @GestureState private var dragOffset = CGSize.zero
    @State private var position = CGSize.zero
    @State private var optionBackgroundColor = Color.white
    
    @ObservedObject var alarmData: AlarmData
    
    @State var inEditing: Bool = false
    @State var inViewing: Bool = false
    
    var swipeReveal: some Gesture {
        DragGesture()
        .updating($dragOffset, body: { (value, state, transaction) in
            state.width = max(-2*DRAG_LIMIT, min(value.translation.width, DRAG_LIMIT))
        })
        .onEnded { (value) in
            if value.translation.width <= -2*DRAG_LIMIT {
                self.managedObjectContext.delete(self.alarmData)
                self.alarmData.objectWillChange.send()
            } else if value.translation.width <= -DRAG_LIMIT {
                self.position.width = -DRAG_LIMIT
            } else if value.translation.width >= DRAG_LIMIT {
                self.inEditing = true
            } else {
                self.position.width = 0
            }
        }
    }
    
    var tapGuesture: some Gesture {
        TapGesture(count: 1)
        .onEnded { _ in
            self.inViewing = true
        }
    }
    
    var backgroundColor: Color {
        if self.colorScheme == .dark {
            return Color.black
        } else {
            return Color.white
        }
    }
    
    var body: some View {
        ZStack {
            // Our Background
            HStack {
                // Our leftside button
                VStack{
                    Spacer()
                    HStack{
                        Spacer().frame(width: DEFAULT_LEFT_ALIGN_SPACE)
                        Image(systemName: "square.and.pencil")
                            .resizable()
                            .frame(width: 30, height: 30)
                        Spacer().frame(width: DEFAULT_LEFT_ALIGN_SPACE)
                        Spacer()
                    }
                    Spacer()
                }
                    
                // Our rightside button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Spacer().frame(width: DEFAULT_LEFT_ALIGN_SPACE)
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 30, height: 30)
                        Spacer().frame(width: DEFAULT_LEFT_ALIGN_SPACE)
                    }
                    Spacer()
                }
            }.background(
                (self.position.width + self.dragOffset.width <= 0) ?
                    Color.red : Color.blue
            )
            
            // Our foreground
            HStack {
                VStack {
                    Spacer()
                    HStack {
                        Spacer().frame(width: DEFAULT_LEFT_ALIGN_SPACE)
                        VStack {
                            Text(self.alarmData.name).font(Font.title)
                        }
                        VStack {
                            HStack{
                                Spacer()
                                HStack{
                                    Text("Time: ")
                                    Text(self.alarmData.time.stringHMS())
                                }
                                Spacer().frame(width: DEFAULT_LEFT_ALIGN_SPACE)
                            }
                            HStack {
                                Spacer()
                                HStack {
                                    Text("Duration: ")
                                    Text(self.alarmData.duration.stringHMS())
                                }
                                Spacer().frame(width: DEFAULT_LEFT_ALIGN_SPACE)
                            }
                        }
                    }
                    Spacer().frame(height: 20)
                    HStack {
                        DaysOfWeekView(daysOfWeek: Set(self.alarmData.daysOfWeek))
                        Spacer().frame(width: DEFAULT_LEFT_ALIGN_SPACE)
                    }
                    Spacer()
                }
            }
            .background(self.backgroundColor)
            .offset(x: self.position.width + dragOffset.width)
            // .animation(.easeInOut) // TODO: This doesn't work, make your own animation that incorporates changing background color!
            .gesture(tapGuesture)
            .gesture(swipeReveal)
            
            NavigationLink(
                destination: AlarmEditor(
                    inEditing: self.$inEditing,
                    alarmData: self.alarmData
                ),
                isActive: self.$inEditing
            ) { EmptyView() }
            NavigationLink(
                destination: TaskListView(
                    inViewing: self.$inViewing,
                    alarmData: self.alarmData
                ),
                isActive: self.$inViewing
            ) { EmptyView() }
        }.frame(height:100)
    }
}

struct AlarmsRow_Previewer: View {
    @State var alarmData: AlarmData
    var body: some View {
        AlarmsRow(alarmData: alarmData)
    }
}

struct AlarmsRow_Previews: PreviewProvider {
    static var previews: some View {
        let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let alarmData = AlarmData(context: moc)
        alarmData.id = UUID()
        alarmData.name = "Morning"
        alarmData.daysOfWeek_ = daysOfWeekToInt(daysOfWeek: [
            DayOfWeek.Monday,
            DayOfWeek.Tuesday,
            DayOfWeek.Wednesday,
            DayOfWeek.Thursday,
            DayOfWeek.Friday,
            DayOfWeek.Saturday,
            DayOfWeek.Sunday
        ])
        return AlarmsRow_Previewer(alarmData: alarmData)
    }
}
