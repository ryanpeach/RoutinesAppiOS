//
//  RowMods.swift
//  Routines
//
//  Created by PEACH,RYAN (K-Atlanta,ex1) on 4/18/20.
//  Copyright © 2020 Peach. All rights reserved.
//

import Foundation
import SwiftUI

struct RowMods: View {
    var body: some View {
        Image("turtlerock")
            .clipShape(Circle())
            .contextMenu {
            Button(action: {
            // Action will goes here
            }) {
                Text("Delete")
                Image(systemName: "trash")
            }
            Button(action: {
            // Action will goes here
            }) {
                Text("ADD")
                Image(systemName: "plus")
            }
        }
    }
}

struct RowMods_Previews: PreviewProvider {
    static var previews: some View {
        RowMods()
    }
}
