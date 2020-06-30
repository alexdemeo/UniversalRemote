//
//  ComponentDeviceInputs.swift
//  MyRemote
//
//  Created by Alex DeMeo on 6/28/20.
//  Copyright © 2020 Alex DeMeo. All rights reserved.
//

import SwiftUI

struct ComponentDevices: View {
    var buttonPC: RemoteButton
    var buttonTV: RemoteButton
    var buttonAVR: RemoteButton
    var buttonPi2: RemoteButton
    var buttonPS3: RemoteButton
    
    var body: some View {
        VStack(alignment: .center, spacing: Constants.SPACING_VERTICAL) {
            HStack(spacing: Constants.REMOTE_CENTER_GAP_WIDTH) {
                Button(action: buttonPC.exec) { Text(buttonPC.symbol) }.scaleEffect(2.0)
                Button(action: buttonTV.exec) { Text(buttonTV.symbol) }.scaleEffect(2.0)
                Button(action: buttonAVR.exec) { Text(buttonAVR.symbol) }.scaleEffect(2.0)
            }
            HStack(spacing: Constants.REMOTE_CENTER_GAP_WIDTH) {
                Button(action: buttonPi2.exec) { Text(buttonPi2.symbol) }.scaleEffect(2.0)
                Button(action: buttonPS3.exec) { Text(buttonPS3.symbol) }.scaleEffect(2.0)
            }
        }
    }
}

struct ComponentDeviceInputs_Previews: PreviewProvider {
    static var previews: some View {
        ComponentDevices(buttonPC: Buttons.Roku.DEV_PC,
                         buttonTV: Buttons.Roku.VOLUME_DOWN,
                         buttonAVR: Buttons.Roku.POWER,
                         buttonPi2: Buttons.Roku.DEV_PI2,
                         buttonPS3: Buttons.Roku.ASTERISK)
    }
}
