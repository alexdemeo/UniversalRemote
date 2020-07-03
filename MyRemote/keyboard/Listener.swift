//
//  Listener.swift
//  MyRemote
//
//  Created by Alex DeMeo on 6/29/20.
//  Copyright © 2020 Alex DeMeo. All rights reserved.
//

import Cocoa
import SwiftUI

func keyDown(keycode: UInt16, mode: KeyboardMode) { // add param shift: Bool for if shift is pressed, adding caps accordingly
    if let key = KEYS[keycode] {
        print("Input: ", key, " for mode: ", mode)
        switch mode {
        case .off:
            print("Uhh, 2+2=5")
        case .roku:
            keyRoku(key: key)
        case .cec:
            keyCEC(key: key)
        }
    }
}

func keyRoku(key: String) {
    if let btn = Constants.DEFAULT_KEYBINDS_ROKU[key] {
        print("from keyboard: \(btn.symbol)")
        btn.exec()
    } else {
        if key.count == 1 && "abcdefghijklmnopqrstuvwxyz1234567890".contains(key) {
            RemoteButton.roku(endpoint: .keypress, args: ["Lit_\(key)"])
        } else if key == "space" {
            RemoteButton.roku(endpoint: .keypress, args: ["Lit_%20"])
        } else if key == "backspace" {
            RemoteButton.roku(endpoint: .keypress, args: ["Backspace"])
        }
    }
}

func keyCEC(key: String) {
    if let btn = Constants.DEFAULT_KEYBINDS_CEC[key] {
        print("from keyboard: \(btn.symbol)")
        btn.exec()
    } else {
        print("CEC unrecognized button")
    }
}
