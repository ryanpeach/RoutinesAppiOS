//
//  Checkbox.swift
//  Routines
//
//  Created by PEACH,RYAN (K-Atlanta,ex1) on 4/14/20.
//  Copyright © 2020 Peach. All rights reserved.
//

import SwiftUI

struct Checkbox: View {
    var action: () -> () = {}
    
    @State var done: Bool = false
    
    var body: some View {
        Button(action: {
            /*
            if self.lastEdited==nil {
                self.done = false
                self.lastEdited = Date()
            } else if self.lastEdited! < self.threshold {
                self.done = false
            } else {
                self.done.toggle()
                self.action()
            }
             */
        }) {
            Image(systemName: self.done ? "circle.fill" : "circle")
                .frame(width: 30, height: 30)
        }
    }
}

struct Checkbox_Previewer: View {
    @State var done: Bool = false
    @State var lastEdited: Date?
    var body: some View {
        Checkbox(
            action: {}
        )
    }
}

struct Checkbox_Previews: PreviewProvider {
    static var previews: some View {
        Checkbox_Previewer()
    }
}
