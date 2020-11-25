//
//  Settings.swift
//  MyRemote
//
//  Created by Alex DeMeo on 6/30/20.
//  Copyright © 2020 Alex DeMeo. All rights reserved.
//

import Foundation

enum CodingKeys: CodingKey {
    case ipRoku, ipPi, keyboardMode
}

class Settings : ObservableObject { // this needs to be a reference type
    @Published var ipRoku: String
    @Published var keyboardMode: KeyboardMode
    @Published var isRokuOnly: Bool
    
    var refreshToken: String? {
        get {
            let defaults = UserDefaults.standard
            let result = defaults.string(forKey: "refreshToken")
//            print("got refreshToken=\(String(describing: result))")
            return result
        }
        set {
            if let val = newValue {
                let defaults = UserDefaults.standard
//                print("saved refreshToken=\(val)")
                defaults.set(val, forKey: "refreshToken")
            }
        }
    }
    
    private static let path = URL(fileURLWithPath: "settings.json")
    private static let firstTimeKey = "firstTime"

    var rokuBaseURL: String {
        "http://\(AppDelegate.settings.ipRoku):8060"
    }
    
//    AppDelegate.instance().net(url: "http://\(AppDelegate.settings().ipRoku):8060\(self.commandStr)", method: "POST")

    init(ipRoku: String, keyboardMode: KeyboardMode, isRokuOnly: Bool, refreshToken: String?) {
        self.ipRoku = ipRoku
        self.keyboardMode = keyboardMode
        self.isRokuOnly = isRokuOnly
        self.refreshToken = refreshToken
    }
    
    
    func save() {
//        print("saving settings...")
//        self.printSettings()
        let defaults = UserDefaults.standard
        defaults.set(self.ipRoku, forKey: "ipRoku")
        defaults.set(self.keyboardMode.rawValue, forKey: "keyboardMode")
        defaults.set(self.isRokuOnly, forKey: "isRokuOnly")
        defaults.set(self.refreshToken, forKey: "refreshToken")
    }
    
    func printSettings() {
        print("\tipRoku=\(self.ipRoku)")
        print("\tkeyboardMode=\(self.keyboardMode)")
        print("\tisRokuOnly=\(self.isRokuOnly)")
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
            let res = Settings(ipRoku:          defaults.string(forKey: "ipRoku")!,
                               keyboardMode:    KeyboardMode(rawValue: defaults.string(forKey: "keyboardMode")!)!,
                               isRokuOnly:      defaults.bool(forKey: "isRokuOnly"),
                               refreshToken:    defaults.string(forKey: "refreshToken"))
            print("loaded=", res.ipRoku)
//            res.printSettings()
            return res
        }
    }
}
