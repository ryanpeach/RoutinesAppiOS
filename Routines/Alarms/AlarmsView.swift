//
//  ContentView.swift
//  Routines
//
//  Created by PEACH,RYAN (K-Atlanta,ex1) on 4/12/20.
//  Copyright © 2020 Peach. All rights reserved.
//

import SwiftUI
import CoreData
import Combine

struct MyBackButton: View {
    let label: String
    let closure: () -> ()

    var body: some View {
        Button(action: { self.closure() }) {
            HStack {
                Image(systemName: "chevron.left")
                Text(label)
            }
        }
    }
}

struct AlarmsView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        entity: AlarmData.entity(),
        sortDescriptors: [
            NSSortDescriptor(
                keyPath: \AlarmData.time_,
                ascending: true
            )
    ]) var alarmDataList: FetchedResults<AlarmData>
    
    @State var createMode = false
    @State var editMode = false
    @State var taskListMode = false
    @State var tag: AlarmData?
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    ForEach(self.alarmDataList, id: \.id) { al in
                        VStack {
                            AlarmsRow(
                                tag: self.$tag,
                                alarmData: al
                            )
                            NavigationLink(destination: TaskListView(alarmData: al), tag: al, selection: self.$tag) {
                                EmptyView()
                            }
                        }
                    }
                    .onDelete(perform: self.delete)
                }
                Spacer()
                
                // Add Item Button
                Button(action: {
                    self.createMode = true
                }) {
                    HStack {
                        Text("Add Item")
                        Image(systemName: "plus")
                    }
                }
                NavigationLink(
                    destination: AlarmCreator(createMode: self.$createMode),
                    isActive: $createMode
                ) { EmptyView() }
            }
            .navigationBarTitle(Text("Routines"))
        }
    }
    
    func delete(at offsets: IndexSet) {
        for index in offsets {
            let alarmData = alarmDataList[index]
            managedObjectContext.delete(alarmData)
        }
    }
}


struct AlarmsView_Previews: PreviewProvider {
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
            DayOfWeek.Friday
        ])
        /*
        do {
            try self.moc.save()
        } catch {
            // handle the Core Data error
        }
        */
        return AlarmsView()
    }
}

