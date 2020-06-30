//
//  Buttons.swift
//  MyRemote
//
//  Created by Alex DeMeo on 6/29/20.
//  Copyright © 2020 Alex DeMeo. All rights reserved.
//

import Foundation

struct RemoteButton {
    var type: RemoteType
    var symbol: String
    var endpoint: CommandEndpoint
    var command: String
    var keyboardKey: String?
    
    func exec() {
        switch self.type {
        case .roku:
            RemoteButton.roku(endpoint: self.endpoint, args: [command])
        case .cec:
            print("cec not yet implemented")
        }
    }
    
    static func roku(endpoint: CommandEndpoint, args: [String]) {
        net(url: "http://192.168.1.219:8060/\(endpoint)/\(args.joined(separator: "/"))", method: "POST")
    }
    
    static private func net(url: String, method: String) {
        print("net(url: \(url), method: \(method))")
         var req = URLRequest(url: URL(string: url)!)
         req.httpMethod = method
         let task = URLSession.shared.dataTask(with: req) { data, response, error in
             print("\tRESULT from: \(url)")
             print("\t\tdata=\(String(describing: data))")
             print("\t\tresponse=\(String(describing: response))")
             print("\t\terror=\(String(describing: error))")
         }
         task.resume()
     }
}

struct Buttons {
    struct Roku {
        static let MUTE             = RemoteButton(type: .roku, symbol: "🔇", endpoint: .keypress, command: "Mute")
        static let POWER            = RemoteButton(type: .roku, symbol: "🔌", endpoint: .keypress, command: "Power")
        static let VOLUME_DOWN      = RemoteButton(type: .roku, symbol: "−", endpoint: .keypress, command: "VolumeDown")
        static let VOLUME_UP        = RemoteButton(type: .roku, symbol: "＋", endpoint: .keypress, command: "VolumeUp")
        static let DOWN             = RemoteButton(type: .roku, symbol: "↓", endpoint: .keypress, command: "Down")
        static let UP               = RemoteButton(type: .roku, symbol: "↑", endpoint: .keypress, command: "Up")
        static let LEFT             = RemoteButton(type: .roku, symbol: "←", endpoint: .keypress, command: "Left")
        static let RIGHT            = RemoteButton(type: .roku, symbol: "→", endpoint: .keypress, command: "Right")
        static let OK               = RemoteButton(type: .roku, symbol: "OK", endpoint: .keypress, command: "Select")
        static let BACK             = RemoteButton(type: .roku, symbol: "↲", endpoint: .keypress, command: "Back")
        static let HOME             = RemoteButton(type: .roku, symbol: "⌂", endpoint: .keypress, command: "Home")
        static let REFRESH          = RemoteButton(type: .roku, symbol: "↻", endpoint: .keypress, command: "InstalReplay")
        static let DO_NOT_DISTURB   = RemoteButton(type: .roku, symbol: "☽", endpoint: .keypress, command: "?")
        static let ASTERISK         = RemoteButton(type: .roku, symbol: "✱", endpoint: .keypress, command: "Info")
        static let REWIND           = RemoteButton(type: .roku, symbol: "⦉⦉", endpoint: .keypress, command: "Rev")
        static let PLAY_PLAUSE      = RemoteButton(type: .roku, symbol: "▻⫾⫾", endpoint: .keypress, command: "Play")
        static let FORWARD          = RemoteButton(type: .roku, symbol: "⦊⦊", endpoint: .keypress, command: "Rew")
        
        static let DEV_AVR          = RemoteButton(type: .roku, symbol: "AVR", endpoint: .keypress, command: "InputHDMI1")
        static let DEV_PI2          = RemoteButton(type: .roku, symbol: "pi2", endpoint: .keypress, command: "InputHDMI2")
        static let DEV_PC           = RemoteButton(type: .roku, symbol: "PC", endpoint: .keypress, command: "InputHDMI3")
        
        static let NETFLIX          = RemoteButton(type: .roku, symbol: "Netflix", endpoint: .launch, command: "12")
        static let HULU             = RemoteButton(type: .roku, symbol: "Hulu", endpoint: .launch, command: "2285")
        static let YOUTUBE          = RemoteButton(type: .roku, symbol: "YouTube", endpoint: .launch, command: "837")
        static let SPOTIFY          = RemoteButton(type: .roku, symbol: "Spotify", endpoint: .launch, command: "19977")
    }

    struct CEC {
        
    }
}
