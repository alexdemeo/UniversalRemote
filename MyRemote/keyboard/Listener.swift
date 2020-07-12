//
//  Listener.swift
//  MyRemote
//
//  Created by Alex DeMeo on 6/29/20.
//  Copyright © 2020 Alex DeMeo. All rights reserved.
//

import Cocoa
import SwiftUI

func keyDown(keycode: UInt16, mode: KeyboardMode, shiftDown: Bool) {
    if let key = KEYS[keycode] {
        switch mode {
        case .off:
            print("Uhh, 2+2=5")
        case .roku:
            keyRoku(key: key, shiftDown: shiftDown)
        case .cec:
            keyCEC(key: key)
        }
    }
}

func keyRoku(key: String, shiftDown: Bool) {
    if let btn = Constants.DEFAULT_KEYBINDS_ROKU[key] {
        print("from keyboard: \(btn.symbol)")
        btn.exec()
    } else {
        if key.count == 1 && "abcdefghijklmnopqrstuvwxyz1234567890".contains(key) {
            let sentKey = shiftDown ? key.uppercased() : key
            RemoteButton(type: .roku, symbol: key, endpoint: .keypress, command: "Lit_\(sentKey)").exec()
        } else if key == "space" {
            RemoteButton(type: .roku, symbol: key, endpoint: .keypress, command: "Lit_%20").exec()
        } else if key == "backspace" {
            RemoteButton(type: .roku, symbol: key, endpoint: .keypress, command: "Backspace").exec()
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
