//
//  Net.swift
//  MyRemote
//
//  Created by Alex DeMeo on 6/30/20.
//  Copyright © 2020 Alex DeMeo. All rights reserved.
//

import Foundation

var latestRequest: URLRequest? = nil
var latestResponse: (Data?, HTTPURLResponse?, Error?)? = nil

struct RemoteButton {
    var type: RemoteType
    var symbol: String
    var endpoint: CommandEndpoint
    var command: String
    
    var commandStr: String {
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
        self.net(url: "http://\(AppDelegate.settings().ipRoku):8060\(self.commandStr)", method: "POST")
    }
    
    private func cec(method: String) {
        self.net(url: "http://\(AppDelegate.settings().ipPi):5000\(self.commandStr)", method: method)
    }
    
    private func net(url: String, method: String) {
        print("net(url: \(url), method: \(method))")
        var req = URLRequest(url: URL(string: url)!)
        req.httpMethod = method
        latestRequest = req
        let task = URLSession.shared.dataTask(with: req) { data, response, error in
            latestResponse = (data, response as? HTTPURLResponse, error)
            print("\tRESULT from: \(url)")
            print("\t\tdata=\(String(describing: data))")
            print("\t\tresponse=\(String(describing: response))")
            print("\t\terror=\(String(describing: error))")
        }
        task.resume()
    }
}
