//
//  ContentView.swift
//  Routines
//
//  Created by PEACH,RYAN (K-Atlanta,ex1) on 4/12/20.
//  Copyright © 2020 Peach. All rights reserved.
//

import SwiftUI
import CoreData

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
    
    var body: some View {
        NavigationView {
            VStack {
                List{
                    ForEach(self.alarmDataList, id: \.id) { al in
                        AlarmsRow(alarmData: al)
                    }
                    .onDelete(perform: self.delete)
                }
                .padding(10)
                .navigationBarTitle(Text("Alarms"))
                .navigationBarItems(trailing: EditButton())
                
                // Add Item Button
                NavigationLink(
                    destination: AlarmCreator()
                ) {
                    HStack {
                        Text("Add Item")
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
    
    func delete(at offsets: IndexSet) {
        for index in offsets {
            let alarmData = alarmDataList[index]
            managedObjectContext.delete(alarmData)
        }
    }
}
