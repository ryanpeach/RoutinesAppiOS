//
//  ContentView.swift
//  Routines
//
//  Created by PEACH,RYAN (K-Atlanta,ex1) on 4/12/20.
//  Copyright © 2020 Peach. All rights reserved.
//

import SwiftUI

struct AlarmsView: View {
    @State var alarmDataList: Array<AlarmData>
    
    var body: some View {
        NavigationView {
            List{
                ForEach(0..<self.alarmDataList.count) { i in
                    AlarmsRow(alarm: self.$alarmDataList[i])
                }
                .onDelete(perform: self.delete)
                .onMove(perform: self.move)
            }
            .padding(10)
            .navigationBarTitle(Text("Alarms"))
            .navigationBarItems(trailing: EditButton())
        }
    }
    
    func delete(at offsets: IndexSet) {
        self.alarmDataList.remove(atOffsets: offsets)
    }
    
    func move(from source: IndexSet, to destination: Int) {
        self.alarmDataList.move(fromOffsets: source, toOffset: destination)
    }
}

struct AlarmsView_Previews: PreviewProvider {
    static var previews: some View {
        AlarmsView(alarmDataList: alarmDataList)
    }
}
