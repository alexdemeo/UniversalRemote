//
//  ContentViewSettings.swift
//  MyRemote
//
//  Created by Alex DeMeo on 6/25/20.
//  Copyright © 2020 Alex DeMeo. All rights reserved.
//

import SwiftUI

struct ContentViewSettings: View {
    @EnvironmentObject var settings: Settings
    
    var body: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading) {
                HStack {
                    Text("Roku IP")
                        .frame(width: 50.0)
                    TextField(settings.ipRoku, text: $settings.ipRoku)
                        .frame(width: 90)
                }
                HStack {
                    Text("   RPi IP")
                        .frame(width: 50.0)
                    TextField(settings.ipPi, text: $settings.ipPi)
                        .frame(width: 90)
                }
            }
            VStack {
                Text("Keyboard")
                Picker("Keyboard", selection: $settings.keyboardMode) {
                    Text("Off").tag(KeyboardMode.off)
                    Text("Roku").tag(KeyboardMode.roku)
                    Text("CEC").tag(KeyboardMode.cec)
                    }.pickerStyle(RadioGroupPickerStyle()).labelsHidden()
            }
        }
    }
}

struct ContentViewSettings_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewSettings()
            .frame(width: Constants.REMOTE_WIDTH, height: Constants.WINDOW_HEIGHT / 5).environmentObject(Settings.load()!)
    }
}
