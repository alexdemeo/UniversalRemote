//
//  CompRemotesPicker.swift
//  MyRemote
//
//  Created by Alex DeMeo on 11/24/20.
//  Copyright © 2020 Alex DeMeo. All rights reserved.
//

import SwiftUI

struct RemoteCell: View {
    let index: Int
    @State var enabled: Bool
    @EnvironmentObject var settings: Settings
    
    var remoteData: RemoteData {
        settings.remotes[self.index]
    }
    
    var body: some View {
        VStack {
            Text(self.remoteData.title.localizedCapitalized)
            Toggle(isOn: $settings.remotes[self.index].enabled) {
            }.toggleStyle(CheckboxToggleStyle())
            
        }
    }
}

struct ComponentRemotePicker: View {
    @EnvironmentObject var settings: Settings
    
    @State private var editIndex: Int = 0
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(settings.remotes.indices) { i in
                let remoteEntry = settings.remotes[i]
                if i == self.editIndex && i > 0{
                    Button("<") {
                        self.editIndex -= 1
                        print("< \(i) -> \(self.editIndex)")
                        settings.remotes.swapAt(i, self.editIndex)
                    }
                }
                VStack {
                    if i == self.editIndex {
                        RemoteCell(
                            index: i,
                            enabled: remoteEntry.enabled
                        ).scaleEffect(1.25)
                    } else {
                        RemoteCell(
                            index: i,
                            enabled: remoteEntry.enabled
                        ).onTapGesture {
                            self.editIndex = i
                        }
                    }
                }
                if i == self.editIndex && i < settings.remotes.count - 1 {
                    Button(">") {
                        self.editIndex += 1
                        print("< \(i) -> \(self.editIndex)")
                        settings.remotes.swapAt(i, self.editIndex)
                    }
                }
            }
        }
    }
}

struct ComponentRemotePicker_Previews: PreviewProvider {
    static var previews: some View {
        //        ComponentRemotePicker()
        ContentViewSettings()
            .environmentObject(Settings.load()!)
    }
}
