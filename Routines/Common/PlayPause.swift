//
//  PlayPause.swift
//  Routines
//
//  Created by PEACH,RYAN (K-Atlanta,ex1) on 4/14/20.
//  Copyright © 2020 Peach. All rights reserved.
//

import SwiftUI

struct PlayPause: View {
    
    @Binding var isPlay: Bool
    var afterAction: () -> () = {}
    
    var body: some View {
        Button(action: {
            self.isPlay.toggle()
            self.afterAction()
        }) {
            Image(systemName: self.isPlay ? "pause" : "play")
                .frame(width: DEFAULT_LEFT_ALIGN_SPACE, height: 30)
        }
    }
}


struct PlayPause_Previewer: View {
    @State var isPlay: Bool = false
    var body: some View {
        PlayPause(isPlay: self.$isPlay)
    }
}

struct PlayPause_Previews: PreviewProvider {
    static var previews: some View {
        PlayPause_Previewer()
    }
}
