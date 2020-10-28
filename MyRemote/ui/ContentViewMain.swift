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
    @EnvironmentObject var latestRequest: Request
    @EnvironmentObject var latestResponse: Response
    @EnvironmentObject var rokuChannelButtons: ObservedRokuButtons
    
    var body: some View {
        let command: String = AppDelegate.sanitizeURL(url: latestRequest.request?.url?.absoluteString ?? "") ?? "error"
        var success = latestResponse.error == nil
        if let resp = latestResponse.response {
            success = success && resp.statusCode == 200
        }
        let msg = success ? nil : latestResponse.error?.localizedDescription
        return VStack {
            HStack {
                if self.debugRemote == nil || self.debugRemote == .roku {
                    ContentViewRoku()
                }
                if !self.settings.isRokuOnly {
                    if self.debugRemote == nil {
                        Divider().padding(.horizontal)
                    }
                    if self.debugRemote == nil || self.debugRemote == .cec {
                        ContentViewCEC()
                    }
                }
            }
            Divider()
            Picker("Keyboard", selection: $settings.keyboardMode) {
                Text("Keyboard Off").tag(KeyboardMode.off)
                Text("Roku Keyboard").tag(KeyboardMode.roku)
                if !self.settings.isRokuOnly {
                    Text("CEC Keyboard").tag(KeyboardMode.cec)
                }
            }.pickerStyle(SegmentedPickerStyle()).labelsHidden()
            ComponentStatus(command: command, msg: msg, success: success, statusCode: latestResponse.response?.statusCode ?? -1)
            if self.displaySettingsPane.shown {
                ContentViewSettings().padding(.vertical)
                Button(action: {
                    self.settings.save()
                    self.displaySettingsPane.shown.toggle()
                    self.rokuChannelButtons.sendRefreshRequest()
                }) {
                    Text("Save")
                }.buttonStyle(DefaultButtonStyle())
            } else {
                Button(action: {
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
            .environmentObject(AppDelegate.settings)
            .environmentObject(AppDelegate.instance.displaySettingsPane)
            .environmentObject(AppDelegate.instance.latestRequest)
            .environmentObject(AppDelegate.instance.latestResponse)
            .environmentObject(AppDelegate.instance.rokuChannelButtons)
            .buttonStyle(BorderlessButtonStyle())
    }
}
