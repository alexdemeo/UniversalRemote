//
//  ContentViewHome.swift
//  MyRemote
//
//  Created by Alex DeMeo on 11/25/20.
//  Copyright © 2020 Alex DeMeo. All rights reserved.
//

import SwiftUI

let pi3URL = "http://pi3.local:5000"
let pi2URL = "http://pi2.local:5555"

struct ContentViewHome: View {
    var body: some View {
        VStack(alignment: .center) {
            ComponentCoffee()
            Divider()
            Spacer()
            Divider()
            ComponentPrinterStation()
        }
    }
}


struct ContentViewHome_Previews: PreviewProvider {
    static var previews: some View {
        ComponentCoffee()
            .buttonStyle(BorderlessButtonStyle())
    }
}
