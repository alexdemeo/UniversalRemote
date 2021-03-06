//
//  ComponentTop.swift
//  MyRemote
//
//  Created by Alex DeMeo on 6/26/20.
//  Copyright © 2020 Alex DeMeo. All rights reserved.
//

import SwiftUI

struct ComponentTop: View {
    var buttonVolumeUp: RemoteButton
    var buttonVolumeDown: RemoteButton
    var buttonPower: RemoteButton
    var buttonMute: RemoteButton
    
    var body: some View {
        VStack(alignment: .center, spacing: Constants.SPACING_VERTICAL) {
            HStack(alignment: .top) {
                Button(action: buttonVolumeUp.exec) {
                    Text(buttonVolumeUp.symbol)
                }
                Spacer().frame(width: Constants.CELL_WIDTH)
                Button(action: buttonPower.exec) {
                    Text(buttonPower.symbol)
                }
            }
            HStack(alignment: .top) {
                Button(action: buttonVolumeDown.exec) {
                    Text(buttonVolumeDown.symbol)
                }
                Spacer().frame(width: Constants.CELL_WIDTH)
                Button(action: buttonMute.exec) {
                    Text(buttonMute.symbol)
                }
            }
        }
    }
}

struct ComponentTop_Previews: PreviewProvider {
    static var previews: some View {
        ComponentTop(buttonVolumeUp: Buttons.Roku.VOLUME_UP,
                     buttonVolumeDown: Buttons.Roku.VOLUME_DOWN,
                     buttonPower: Buttons.Roku.POWER,
                     buttonMute: Buttons.Roku.MUTE)
            .buttonStyle(BorderlessButtonStyle())
            .frame(width: 300, height: 300)
    }
}
