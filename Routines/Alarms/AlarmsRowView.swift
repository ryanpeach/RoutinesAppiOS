//
//  AlarmsRow.swift
//  Routines
//
//  Created by PEACH,RYAN (K-Atlanta,ex1) on 4/12/20.
//  Copyright © 2020 Peach. All rights reserved.
//

import SwiftUI
import CoreData


struct AlarmRowForeground: View {
    @ObservedObject var alarmData: AlarmData
    var body: some View {
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
    }
}


struct AlarmsRowView: View {
    @Environment(\.managedObjectContext) private var managedObjectContext

    @Binding var tag: AlarmData?
    @ObservedObject var alarmData: AlarmData
    
    @State private var inEditing: Bool = false
    
    var body: some View {
        ZStack {
            AlarmRowForeground(alarmData: self.alarmData)
                .onTapGesture(count: 1) {
                    self.tag = self.alarmData
                }
                .contextMenu {
                    Button(action: {self.tag = self.alarmData}) {
                        HStack {
                            Text("List")
                            Image(systemName: "list.bullet")
                        }
                    }
                    Button(action: {
                        self.inEditing = true
                    }) {
                        HStack {
                            Text("Edit")
                            Image(systemName: "square.and.pencil")
                        }
                    }
                    /*
                    Button(action: {
                        self.managedObjectContext.delete(self.alarmData)
                    }, label: {
                        HStack {
                            Text("Remove")
                            Image(systemName: "trash")
                        }.foregroundColor(Color.red)
                    })
                    */
            }
            
            // This Navigation Link uses the "isActive" method of creating a link to AlarmEditor,
            // Based on the Edit button in the above context menu.
            // Since it comes right back to this view, this works well.
            NavigationLink(
                destination: AlarmEditorView(
                    inEditing: self.$inEditing,
                    alarmData: self.alarmData
                ),
                isActive: self.$inEditing
            ) { EmptyView() }
        }.frame(height:100)
    }
}

struct AlarmsRow_Previewer: View {
    @State var alarmData: AlarmData
    @State var tag: AlarmData?
    var body: some View {
        AlarmsRowView(
            tag: $tag,
            alarmData: alarmData
        )
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
