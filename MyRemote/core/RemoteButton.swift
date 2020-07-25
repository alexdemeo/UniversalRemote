//
//  Net.swift
//  MyRemote
//
//  Created by Alex DeMeo on 6/30/20.
//  Copyright © 2020 Alex DeMeo. All rights reserved.
//

import Foundation

struct RemoteButton : Identifiable {
    let type: RemoteType
    let symbol: String
    let endpoint: CommandEndpoint
    let command: String
    let id: String
    let associatedApp: RokuApp?
    
    init(forType type: RemoteType, symbol: String, endpoint: CommandEndpoint, command: String) {
        self.init(forType: type, symbol: symbol, endpoint: endpoint, command: command, associatedApp: nil)
    }
    
    init(forType type: RemoteType, symbol: String, endpoint: CommandEndpoint, command: String, associatedApp: RokuApp?) {
        self.type = type
        self.symbol = symbol
        self.endpoint = endpoint
        self.command = command
        self.id = symbol
        self.associatedApp = associatedApp
    }
    
    private var commandStr: String {
        "/\(self.endpoint)/\([self.command].joined(separator: "/"))"
    }
    
    func exec() {
        switch self.type {
        case .roku:
            self.roku()
        case .cec:
            switch self.endpoint {
            case .power:
                return
            case .volume:
                // temporarily (until PC adapter arrives), volume will be a volume button press, rather than CEC volume change
                self.cec(method: "POST")
            case .key:
                return
            case .transmit:
                return
            case .keypress, .launch:
                print("Somehow got CEC remote with Roku endpoint")
                return
            }
        }
    }
    
    private func roku() {
        if (self.endpoint == .keypress) {
            if self.command == "VolumeUp" && AppDelegate.settings().volume >= Constants.VOL_MAX {
                AppDelegate.settings().volume = Constants.VOL_MAX
                return
            }
            if self.command == "VolumeDown" && AppDelegate.settings().volume <= 0 {
                AppDelegate.settings().volume = 0
                return
            }
        }
        AppDelegate.instance().net(url: "\(AppDelegate.settings().rokuBaseURL)\(self.commandStr)", method: "POST")
    }
    
    private func cec(method: String) {
        AppDelegate.instance().net(url: "\(AppDelegate.settings().cecBaseURL)\(self.commandStr)", method: method)
    }
    
    static func getRokuButtons() -> [RemoteButton] {
        let apps = RokuApp.getApps()
        print("Made buttons for apps:\n\(apps.map({"\t\($0)"}).joined(separator: "\n"))")
        return apps.map({
            RemoteButton(forType: .roku, symbol: $0.name, endpoint: .launch, command: $0.id, associatedApp: $0)
        })
    }
}
