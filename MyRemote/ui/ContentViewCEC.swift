//
//  ContentViewCEC.swift
//  MyRemote
//
//  Created by Alex DeMeo on 6/25/20.
//  Copyright © 2020 Alex DeMeo. All rights reserved.
//

import SwiftUI

struct ContentViewCEC: View {
    var body: some View {
        VStack(alignment: .center) {
            HStack(alignment: .top) {
                Button(action: {
                    
                }) {
                    Text("🔇")
                        .multilineTextAlignment(.leading)
                        .padding(.trailing, 100.0)
                        .frame(width: Constants.CELL_WIDTH)
                    
                }
                Spacer()
                    .padding()
                    .frame(width: -Constants.REMOTE_CENTER_GAP_WIDTH)                
                Button(action: {
                    
                }) {
                    Text("🔌")
                        .multilineTextAlignment(.trailing)
                        .padding(.leading, 100.0)
                        .frame(width: Constants.CELL_WIDTH)
                }
            }
            .padding(.all)
        }
    }
}


struct ContentViewCEC_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewCEC()
    }
}
