//
//  RemoteType.swift
//  MyRemote
//
//  Created by Alex DeMeo on 6/25/20.
//  Copyright © 2020 Alex DeMeo. All rights reserved.
//

import Foundation

enum RemoteType: String, CaseIterable {
    case roku = "Roku"
    case home = "Home"
}

enum CommandEndpoint: String {
    /**************** Roku endpoints ******************/
    case keypress = "keypress"
    case launch = "launch"
    
    /**************** Home endpoints ******************/
    case coffee = "coffee"
}

