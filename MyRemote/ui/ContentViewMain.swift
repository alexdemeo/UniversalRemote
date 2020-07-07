//
//  ContentView.swift
//  MyRemote
//
//  Created by Alex DeMeo on 6/25/20.
//  Copyright © 2020 Alex DeMeo. All rights reserved.
//

import SwiftUI

struct ContentViewMain: View {
    private var debugRemote: RemoteType? = nil
    
    @EnvironmentObject var settings: Settings
    @EnvironmentObject var displaySettingsPane: DisplaySettingsPane
    
    var body: some View {
        return VStack {
            HStack {
                if (self.debugRemote != nil) {
                    if self.debugRemote! == .roku {
                        ContentViewRoku()
                    } else {
                        ContentViewCEC()
                    }
                } else {
                    ContentViewRoku()
                    Divider().padding(.horizontal)
                    ContentViewCEC()
                }
            }
            Divider()
            Picker("Keyboard", selection: $settings.keyboardMode) {
                Text("Keyboard Off").tag(KeyboardMode.off)
                Text("Roku Keyboard").tag(KeyboardMode.roku)
                Text("CEC Keyboard").tag(KeyboardMode.cec)
            }.pickerStyle(SegmentedPickerStyle()).labelsHidden()
            if self.displaySettingsPane.shown {
                ContentViewSettings()
                    .padding(.top)
            }
            HStack {
                Button(action: {
                    if self.displaySettingsPane.shown {
                        self.settings.save()
                    }
                    self.displaySettingsPane.shown.toggle()
                }) {
                    Text("⚙")
                }
            }
        }
        .padding(.all)
    }
}

struct ContentViewMain_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewMain()
            .environmentObject(AppDelegate.settings())
            .environmentObject(AppDelegate.instance().displaySettingsPane)
            .buttonStyle(BorderlessButtonStyle())
    }
}
