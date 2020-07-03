//
//  Net.swift
//  MyRemote
//
//  Created by Alex DeMeo on 6/30/20.
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
            RemoteButton.roku(endpoint: self.endpoint, args: [self.command])
        case .cec:
            switch self.endpoint {
            case .power:
                return
            case .volume:
                // temporarily (until PC adapter arrives), volume will be a volume button press, rather than CEC volume change
                RemoteButton.cec(endpoint: self.endpoint, args: [self.command], method: "POST")
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
    
    static func roku(endpoint: CommandEndpoint, args: [String]) {
        net(url: "http://\(AppDelegate.settings().ipRoku):8060/\(endpoint)/\(args.joined(separator: "/"))", method: "POST")
    }
    
    static func cec(endpoint: CommandEndpoint, args: [String], method: String) {
        net(url: "http://\(AppDelegate.settings().ipPi):5000/\(endpoint)/\(args.joined(separator: "/"))", method: method)
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