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
    let httpMethod: String
    let associatedApp: RokuApp?
    
    init(forType type: RemoteType, symbol: String, endpoint: CommandEndpoint, command: String) {
        self.init(forType: type, symbol: symbol, endpoint: endpoint, command: command,httpMethod: nil, associatedApp: nil)
    }
    
    init(forType type: RemoteType, symbol: String, endpoint: CommandEndpoint, command: String, httpMethod: String?, associatedApp: RokuApp?) {
        self.type = type
        self.symbol = symbol
        self.endpoint = endpoint
        self.command = command
        self.id = symbol
        self.associatedApp = associatedApp
        self.httpMethod = httpMethod ?? "POST"
    }
    
    private var commandStr: String {
        "/\(self.endpoint)/\([self.command].joined(separator: "/"))"
    }
    
    func exec() { // This is a dumb paradigm, I'm too lazy to fix it rn.
        switch self.type {
        case .roku:
            self.roku()
        case .spotify:
            self.spotify()
        case .home:
            self.home()
        }
    }
    
    private func home() {
    }
    
    private func spotify() {
//        if let accessToken = SpotifyAuth.shared.accessToken {
//            let header: [String: String] = [
//                "Accept": "application/json",
//                "Content-Type": "application/json",
//                "Authorization": "Bearer \(accessToken)",
//            ]
//            AppDelegate.instance.netAsync(url: "\(SPOTIFY_URL_API)/v1/me\(self.commandStr)", method: self.httpMethod, header: header, body: nil, callback: nil)
//        } else {
//            print("Error: spotify() no access token")
//            SpotifyAuth.shared.refreshCredentials()
//        }
    }
    
    private func roku() {
        AppDelegate.instance.netAsync(url: "\(AppDelegate.settings.rokuBaseURL)\(self.commandStr)", method: "POST", header: nil, body: nil, callback: nil)
    }
}
