//
//  ComponentStatus.swift
//  MyRemote
//
//  Created by Alex DeMeo on 7/8/20.
//  Copyright © 2020 Alex DeMeo. All rights reserved.
//

import SwiftUI

struct ComponentStatus: View {
    var command: String
    var errormsg: String?
    
    var body: some View {
        HStack {
            Circle().fill(self.errormsg == nil ? Color.green : Color.red).frame(width: 25, height: 25)
            Text(self.errormsg == nil ? self.command : "Error: \(self.errormsg!)")
        }
    }
}

struct ComponentStatus_Previews: PreviewProvider {
    static var previews: some View {
        ComponentStatus(command: "L")
    }
}
