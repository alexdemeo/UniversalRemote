//
//  ContentViewRoku.swift
//  MyRemote
//
//  Created by Alex DeMeo on 6/25/20.
//  Copyright © 2020 Alex DeMeo. All rights reserved.
//

import SwiftUI

struct ContentViewRoku: View {
    @EnvironmentObject var rokuChannelButtons: ObservedRokuButtons
    
    var body: some View {
        VStack(alignment: .center, spacing: Constants.SPACING_VERTICAL) {
            ComponentTop(buttonVolumeUp: Buttons.Roku.VOLUME_UP,
                         buttonVolumeDown: Buttons.Roku.VOLUME_DOWN,
                         buttonPower: Buttons.Roku.POWER,
                         buttonMute: Buttons.Roku.MUTE)
            HStack {
                Button(action: Buttons.Roku.BACK.exec) {
                    Text(Buttons.Roku.BACK.symbol).padding(.trailing, 3)
                }
                Spacer().frame(width: Constants.CELL_WIDTH)
                Button(action: Buttons.Roku.HOME.exec) {
                    Text(Buttons.Roku.HOME.symbol).padding(.bottom, 4)
                }
            }
            ComponentArrows(buttonUp: Buttons.Roku.UP,
                            buttonDown: Buttons.Roku.DOWN,
                            buttonLeft: Buttons.Roku.LEFT,
                            buttonRight: Buttons.Roku.RIGHT,
                            buttonOK: Buttons.Roku.OK)
            HStack {
                Button(action: Buttons.Roku.REFRESH.exec) { Text(Buttons.Roku.REFRESH.symbol) }
                Spacer().frame(width: Constants.CELL_WIDTH)
                Button(action: Buttons.Roku.ASTERISK.exec) { Text(Buttons.Roku.ASTERISK.symbol) }
            }.padding(.bottom)
            HStack(spacing: Constants.REMOTE_CENTER_GAP_WIDTH) {
                Button(action: Buttons.Roku.REWIND.exec) { Text(Buttons.Roku.REWIND.symbol) }
                Button(action: Buttons.Roku.PLAY_PLAUSE.exec) { Text(Buttons.Roku.PLAY_PLAUSE.symbol) }
                Button(action: Buttons.Roku.FORWARD.exec) { Text(Buttons.Roku.FORWARD.symbol) }
            }.padding(.bottom)
            ComponentRokuDevices().padding(.bottom)
        }.padding(.top)
    }
}

struct ContentViewRoku_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewRoku()
            .environmentObject(AppDelegate.instance.rokuChannelButtons)
            .buttonStyle(BorderlessButtonStyle())
    }
}
