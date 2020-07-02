//
//  ContentView.swift
//  MyRemote
//
//  Created by Alex DeMeo on 6/25/20.
//  Copyright © 2020 Alex DeMeo. All rights reserved.
//

import SwiftUI

struct ContentViewMain: View {
    private var debugRemote: RemoteType? = nil

    @EnvironmentObject var settings: Settings
    @EnvironmentObject var displaySettingsPane: DisplaySettingsPane
    
    var body: some View {
        if let remote = debugRemote {
            return remote == .roku ?
                AnyView(ContentViewRoku().frame(width: Constants.REMOTE_WIDTH, height: Constants.REMOTE_HEIGHT)) :
                AnyView(ContentViewCEC().frame(width: Constants.REMOTE_WIDTH, height: Constants.REMOTE_HEIGHT))
        } else {
            return AnyView(
                VStack{
                    HStack {
                        ContentViewRoku()
                        Divider().padding(.horizontal)
                        ContentViewCEC()
                    }
                    if self.displaySettingsPane.shown {
                        Divider()
                        ContentViewSettings()
                    }
                    HStack {
                        Button(action: {
                            if self.displaySettingsPane.shown {
                                self.settings.save()
                            }
                            self.displaySettingsPane.shown.toggle()
                        }) {
                            Text("⚙")
                        }
                    }
                }
                .padding(.all)
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewMain()
    }
}
