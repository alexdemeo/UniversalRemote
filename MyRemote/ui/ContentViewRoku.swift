//
//  ContentViewRoku.swift
//  MyRemote
//
//  Created by Alex DeMeo on 6/25/20.
//  Copyright © 2020 Alex DeMeo. All rights reserved.
//

import SwiftUI

struct ContentViewRoku: View {
    var body: some View {
        VStack(alignment: .center, spacing: Constants.SPACING_VERTICAL) {
            ComponentTop(buttonVolumeUp: Buttons.Roku.VOLUME_UP,
                         buttonVolumeDown: Buttons.Roku.VOLUME_DOWN,
                         buttonPower: Buttons.Roku.POWER,
                         buttonMute: Buttons.Roku.MUTE)
            HStack {
                Button(action: Buttons.Roku.BACK.exec) { Text(Buttons.Roku.BACK.symbol) }
                    .padding(.leading, -12.0)
                    .scaleEffect(/*@START_MENU_TOKEN@*/2.0/*@END_MENU_TOKEN@*/)
                    .alignmentGuide(.leading) { dimension in
                        dimension[.leading]
                }
                Spacer().frame(width: Constants.CELL_WIDTH)
                Button(action: Buttons.Roku.HOME.exec) { Text(Buttons.Roku.HOME.symbol).padding(.bottom, 4) }
                    .scaleEffect(/*@START_MENU_TOKEN@*/2.0/*@END_MENU_TOKEN@*/)
                    .alignmentGuide(.trailing) { dimension in
                        dimension[.trailing]
                }
            }.padding(.top)
            ComponentArrows(buttonUp: Buttons.Roku.UP,
                            buttonDown: Buttons.Roku.DOWN,
                            buttonLeft: Buttons.Roku.LEFT,
                            buttonRight: Buttons.Roku.RIGHT,
                            buttonOK: Buttons.Roku.OK)
            HStack {
                Button(action: Buttons.Roku.REFRESH.exec) { Text(Buttons.Roku.REFRESH.symbol) }
                    .scaleEffect(2.0)
                Spacer().frame(width: Constants.CELL_WIDTH)
                Button(action: Buttons.Roku.ASTERISK.exec) { Text(Buttons.Roku.ASTERISK.symbol) }.scaleEffect(2.0)
            }.padding(.bottom)
            HStack(spacing: Constants.REMOTE_CENTER_GAP_WIDTH) {
                Button(action: Buttons.Roku.REWIND.exec) { Text(Buttons.Roku.REWIND.symbol) }.scaleEffect(2.0)
                Button(action: Buttons.Roku.PLAY_PLAUSE.exec) { Text(Buttons.Roku.PLAY_PLAUSE.symbol) }.scaleEffect(2.0)
                Button(action: Buttons.Roku.FORWARD.exec) { Text(Buttons.Roku.FORWARD.symbol) }.scaleEffect(2.0)
            }.padding(.bottom)
            HStack(spacing: Constants.REMOTE_CENTER_GAP_WIDTH * 2) {
                Button(action: Buttons.Roku.NETFLIX.exec) {
                    Text(Buttons.Roku.NETFLIX.symbol).alignmentGuide(.leading) { dimension in
                        dimension[.leading]
                    }
                }.scaleEffect(2.0)
                Button(action: Buttons.Roku.HULU.exec) { Text(Buttons.Roku.HULU.symbol) }
                    .scaleEffect(2.0).alignmentGuide(.trailing) { dimension in
                        dimension[.trailing]
                }
            }
            HStack(spacing: Constants.REMOTE_CENTER_GAP_WIDTH * 2) {
                Button(action: Buttons.Roku.SPOTIFY.exec) { Text(Buttons.Roku.SPOTIFY.symbol) }
                    .scaleEffect(2.0).alignmentGuide(.leading) { dimension in
                        dimension[.leading]
                }
                Button(action: Buttons.Roku.YOUTUBE.exec ) { Text(Buttons.Roku.YOUTUBE.symbol) }
                    .scaleEffect(2.0).alignmentGuide(.trailing) { dimension in
                        dimension[.trailing]
                }
            }
            HStack(spacing: Constants.REMOTE_CENTER_GAP_WIDTH) {
                Button(action: Buttons.Roku.DEV_PC.exec) { Text(Buttons.Roku.DEV_PC.symbol) }.scaleEffect(2.0)
                Button(action: Buttons.Roku.DEV_PI2.exec) { Text(Buttons.Roku.DEV_PI2.symbol) }.scaleEffect(2.0)
                Button(action: Buttons.Roku.DEV_AVR.exec) { Text(Buttons.Roku.DEV_AVR.symbol) }.scaleEffect(2.0)
            }.padding(.vertical)
        }.padding(.top)
    }
}

struct ContentViewRoku_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewRoku()
            .buttonStyle(BorderlessButtonStyle())
    }
}
