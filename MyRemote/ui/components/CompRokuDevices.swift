//
//  ComponentRokuDevices.swift
//  MyRemote
//
//  Created by Alex DeMeo on 7/14/20.
//  Copyright © 2020 Alex DeMeo. All rights reserved.
//

import SwiftUI

struct ComponentRokuDevices: View {
    let buttons: [RemoteButton]
    
    var body: some View {
        ComponentGroupedView(self.buttons.map({ btn in
            AnyView(Button(action: btn.exec) {
                btn.associatedApp!.view.frame(width: Constants.CELL_WIDTH - Constants.SPACING_VERTICAL, height: Constants.CELL_HEIGHT + Constants.SPACING_VERTICAL).scaledToFit()
            })
        }))
    }
}

struct ComponentRokuDevices_Previews: PreviewProvider {
    static var previews: some View {
        ComponentRokuDevices(buttons: RemoteButton.getRokuButtons())
    }
}
