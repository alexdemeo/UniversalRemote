//
//  ComponentRokuDevices.swift
//  MyRemote
//
//  Created by Alex DeMeo on 7/14/20.
//  Copyright © 2020 Alex DeMeo. All rights reserved.
//

import SwiftUI

struct ComponentRokuDevices: View {
    @EnvironmentObject var rokuChannelButtons: ObservedRokuButtons

    var body: some View {
        if self.rokuChannelButtons.array.isEmpty {
            return AnyView(Text("Couldn't load roku apps. Check IP"))
        } else {
            return AnyView(ComponentGroupedView(self.rokuChannelButtons.array.map({ btn in
                AnyView(Button(action: btn.exec) {
                    btn.associatedApp!.view.frame(width: Constants.CELL_WIDTH - Constants.SPACING_VERTICAL, height: Constants.CELL_HEIGHT + Constants.SPACING_VERTICAL).scaledToFit()
                })
            })))
        }
    }
}

struct ComponentRokuDevices_Previews: PreviewProvider {
    static var previews: some View {
        ComponentRokuDevices()
            .environmentObject(AppDelegate.instance.rokuChannelButtons)
    }
}
