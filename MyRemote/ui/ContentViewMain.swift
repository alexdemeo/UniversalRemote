//
//  ContentView.swift
//  MyRemote
//
//  Created by Alex DeMeo on 6/25/20.
//  Copyright © 2020 Alex DeMeo. All rights reserved.
//

import SwiftUI

struct ContentViewMain: View {
    @State var debugRemote: RemoteType? = .roku
    
    var body: some View {
        if let remote = debugRemote {
            print("Debug: ", remote.rawValue)
            return remote == .roku ?
                AnyView(ContentViewRoku().frame(width: Constants.REMOTE_WIDTH, height: Constants.REMOTE_HEIGHT)) :
                AnyView(ContentViewCEC().frame(width: Constants.REMOTE_WIDTH, height: Constants.REMOTE_HEIGHT))
        } else {
            print("Debug: ", "both")
           return AnyView(HStack {
                ContentViewRoku()
                ContentViewCEC()
           }.frame(width: Constants.WINDOW_WIDTH, height: Constants.WINDOW_HEIGHT))
        }
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewMain()
    }
}
