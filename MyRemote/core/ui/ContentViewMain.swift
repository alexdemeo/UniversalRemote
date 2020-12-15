//
//  ContentView.swift
//  MyRemote
//
//  Created by Alex DeMeo on 6/25/20.
//  Copyright © 2020 Alex DeMeo. All rights reserved.
//

import SwiftUI

struct ContentViewMain: View {
    @EnvironmentObject var settings: Settings
    @EnvironmentObject var displaySettingsPane: DisplaySettingsPane
    @EnvironmentObject var latestRequest: Request
    @EnvironmentObject var latestResponse: Response
    @EnvironmentObject var rokuChannelButtons: ObservedRokuButtons
    
    var settingsView: some View {
        VStack {
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
    }
    
    var body: some View {
        let command: String = NetworkManager.sanitizeURL(url: latestRequest.request?.url?.absoluteString ?? "") ?? "error"
        var success = latestResponse.error == nil
        if let resp = latestResponse.response {
            let statusCode = resp.statusCode
            success = success && (200 <= statusCode) && (statusCode < 300)
        }
        let msg = success ? nil :
            latestResponse.data == nil ? latestResponse.error?.localizedDescription : String(data: latestResponse.data!, encoding: .utf8)
        return VStack {
            HStack {
                Spacer()
                ForEach(settings.remotes.indices) {
                    let remote = settings.remotes[$0]
                    if remote.enabled {
                        if $0 != settings.firstEnabledIndex {
                            Divider().padding(.horizontal)
                        }
                        if remote.title == RemoteType.roku.rawValue {
                            ContentViewRoku()
                        } else if remote.title == RemoteType.spotify.rawValue {
                            ContentViewSpotify()
                        } else if remote.title == RemoteType.home.rawValue {
                            ContentViewHome()
                        }
                    }
                }
                Spacer()
            }
            Divider()
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
        }.padding(.all)
    }
}

struct ContentViewMain_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewMain()
            .environmentObject(AppDelegate.settings)
            .environmentObject(AppDelegate.instance.displaySettingsPane)
            .environmentObject(AppDelegate.instance.networkManager)
            .environmentObject(AppDelegate.instance.rokuChannelButtons)
            .environmentObject(AppDelegate.instance.networkManager.latestRequest)
            .environmentObject(AppDelegate.instance.networkManager.latestResponse)
            .buttonStyle(BorderlessButtonStyle())
    }
}
