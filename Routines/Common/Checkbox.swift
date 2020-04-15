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
    
    @State var isChecked: Bool = false
    
    var body: some View {
        Button(action: {
            self.isChecked.toggle()
            self.action()
        }) {
            Image(systemName: self.isChecked ? "circle" : "circle.fill")
                .frame(width: 30, height: 30)
        }
    }
}

struct Checkbox_Previews: PreviewProvider {
    static var previews: some View {
        Checkbox(action: {})
    }
}
