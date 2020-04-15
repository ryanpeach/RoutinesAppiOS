//
//  PlayPause.swift
//  Routines
//
//  Created by PEACH,RYAN (K-Atlanta,ex1) on 4/14/20.
//  Copyright © 2020 Peach. All rights reserved.
//

import SwiftUI

struct PlayPause: View {
    var action: () -> () = {}
    
    @State var isPlay: Bool = false
    
    var body: some View {
        Button(action: {
            self.isPlay.toggle()
            self.action()
        }) {
            Image(systemName: self.isPlay ? "play" : "pause")
                .frame(width: 30, height: 30)
        }
    }
}

struct PlayPause_Previews: PreviewProvider {
    static var previews: some View {
        PlayPause()
    }
}
