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
                        .frame(width: 100)
                }
                ComponentRemotePicker()
            }
        }
        HStack {
            Text("Default coffee schedule")
            Spacer()
            DatePicker("", selection: $settings.coffeeDefaultSchedTime, displayedComponents: .hourAndMinute).labelsHidden()
        }
        HStack {
            Text("Heat notification delay")
            TextField("", text: $settings.coffeeNotificationDelayMinutes)
                .multilineTextAlignment(.trailing)
                .labelsHidden()
            Text("minutes")
        }
    }
}

struct ContentViewSettings_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewSettings()
            .environmentObject(Settings.load()!)
    }
}
