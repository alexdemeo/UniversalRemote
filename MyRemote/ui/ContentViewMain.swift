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
    
    let buttons: [RemoteButton]
    
    init(buttons: [RemoteButton]) {
        self.buttons = buttons
    }
    
    var body: some View {
        let command: String = AppDelegate.sanitizeURL(url: latestRequest.request?.url?.absoluteString ?? "") ?? "error"
        var success = latestResponse.error == nil
        if let resp = latestResponse.response {
            success = success && resp.statusCode == 200
        }
        let msg = success ? nil : latestResponse.error?.localizedDescription
        return VStack {
            Text("\(self.settings.volume)")
            HStack {
                if (self.debugRemote != nil) {
                    if self.debugRemote! == .roku {
                        ContentViewRoku(buttons: self.buttons)
                    } else {
                        ContentViewCEC()
                    }
                } else {
                    ContentViewRoku(buttons: self.buttons)
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
            ComponentStatus(command: command, msg: msg, success: success, statusCode: latestResponse.response?.statusCode ?? -1)
            if self.displaySettingsPane.shown {
                ContentViewSettings().padding(.vertical)
                Button(action: {
                    self.settings.save()
                    self.displaySettingsPane.shown.toggle()
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
        ContentViewMain(buttons: RemoteButton.getRokuButtons())
            .environmentObject(AppDelegate.settings())
            .environmentObject(AppDelegate.instance().displaySettingsPane)
            .environmentObject(AppDelegate.instance().latestRequest)
            .environmentObject(AppDelegate.instance().latestResponse)
            .buttonStyle(BorderlessButtonStyle())
    }
}
