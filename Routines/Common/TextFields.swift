//
//  TextFields.swift
//  Routines
//
//  Created by PEACH,RYAN (K-Atlanta,ex1) on 4/15/20.
//  Copyright © 2020 Peach. All rights reserved.
//

import SwiftUI

struct TitleTextField: View {
    @Binding var text: String
    let onCommit: () -> () = {}
    var body: some View {
        HStack {
            Spacer().frame(width: 30)
            TextField(
                self.text,
                text: self.$text,
                onCommit: self.onCommit
            ).font(Font.largeTitle)
        }
    }
}

struct ReturnTextField: View {
    let label: String
    @Binding var text: String
    let onCommit: () -> ()
    
    var body: some View {
        TextField(
            self.label,
            text: self.$text,
            onCommit: self.onCommit
        )
    }
}
