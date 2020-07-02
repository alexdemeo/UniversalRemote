//
//  Settings.swift
//  MyRemote
//
//  Created by Alex DeMeo on 6/30/20.
//  Copyright © 2020 Alex DeMeo. All rights reserved.
//

import Foundation

enum KeyboardMode: String, Codable {
    case off = "off"
    case roku = "roku"
    case cec = "cec"
}

enum CodingKeys: CodingKey {
    case ipRoku
    case ipPi
    case keyboardMode
}

class Settings : ObservableObject { // this needs to be a reference type
    @Published var ipRoku: String
    @Published var ipPi: String
    @Published var keyboardMode: KeyboardMode
    
    private static let path = URL(fileURLWithPath: "settings.json")
    private static let firstTimeKey = "firstTime"
    
    
    init(ipRoku: String, ipPi: String, keyboardMode: KeyboardMode) {
        self.ipRoku = ipRoku
        self.ipPi = ipPi
        self.keyboardMode = keyboardMode
        self.save()
    }
    
    func save() {
        print("saving settings...")
        let defaults = UserDefaults.standard
        defaults.set(self.ipRoku, forKey: "ipRoku")
        defaults.set(self.ipPi, forKey: "ipPi")
        defaults.set(self.keyboardMode.rawValue, forKey: "keyboardMode")
    }
    
    
    static func load() -> Settings? {
        let defaults = UserDefaults.standard
        if !defaults.bool(forKey: firstTimeKey) {
            defaults.set(true, forKey: firstTimeKey)
            print("First time, setting default settings")
            let res = Constants.DEFAULT_SETTINGS
            res.save()
            return res
        } else {
            let ipRoku2 = defaults.string(forKey: "ipRoku")!
            let ipPi2 = defaults.string(forKey: "ipPi")!
            let keyboardMode2 = defaults.string(forKey: "keyboardMode")!
            let res = Settings(ipRoku: ipRoku2, ipPi: ipPi2, keyboardMode: KeyboardMode(rawValue: keyboardMode2)!)
            print("loaded=\(res.ipRoku)")
            print("\tipRoku=\(res.ipRoku)")
            print("\tipPi=\(res.ipPi)")
            print("\tkeyboardMode=\(res.keyboardMode)")
            return res
        }
    }
}
