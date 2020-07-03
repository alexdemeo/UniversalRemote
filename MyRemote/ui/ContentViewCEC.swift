//
//  ContentViewCEC.swift
//  MyRemote
//
//  Created by Alex DeMeo on 6/25/20.
//  Copyright © 2020 Alex DeMeo. All rights reserved.
//

import SwiftUI

struct ContentViewCEC: View {
    var body: some View {
        VStack(alignment: .center) {
            ComponentTop(buttonVolumeUp: Buttons.CEC.VOLUME_UP,
                         buttonVolumeDown: Buttons.CEC.VOLUME_DOWN,
                         buttonPower: Buttons.CEC.POWER,
                         buttonMute: Buttons.CEC.MUTE)
        }
    }
}


struct ContentViewCEC_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewCEC()
            .buttonStyle(BorderlessButtonStyle()).frame(width: Constants.REMOTE_WIDTH, height: Constants.REMOTE_HEIGHT)
    }
}
