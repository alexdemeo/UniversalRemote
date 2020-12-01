//
//  Settings.swift
//  MyRemote
//
//  Created by Alex DeMeo on 6/30/20.
//  Copyright © 2020 Alex DeMeo. All rights reserved.
//

import SwiftUI

struct RemoteData: Codable, Equatable {
    var title: String
    var enabled: Bool
}

class Settings : ObservableObject { // this needs to be a reference type
    @Published var ipRoku: String
    @Published var keyboardMode: KeyboardMode
    @Published var remotes: [RemoteData]
    
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
    
    var firstEnabledIndex: Int {
        remotes.firstIndex(where: { $0.enabled }) ?? -1
    }
    
    private static let path = URL(fileURLWithPath: "settings.json")
    private static let firstTimeKey = "firstTime"
    
    var rokuBaseURL: String {
        "http://\(AppDelegate.settings.ipRoku):8060"
    }
    
    init(ipRoku: String, keyboardMode: KeyboardMode, remotes: [RemoteData], refreshToken: String?) {
        self.ipRoku = ipRoku
        self.keyboardMode = keyboardMode
        self.remotes = remotes
        self.refreshToken = refreshToken
    }
    
    func save() {
        print("saving settings...")
        self.printSettings()
        let defaults = UserDefaults.standard
        defaults.set(self.ipRoku, forKey: "ipRoku")
        defaults.set(self.keyboardMode.rawValue, forKey: "keyboardMode")
        let remoteData: [String] = self.remotes.map { String(data: try! JSONEncoder().encode($0), encoding: .utf8)! }
        defaults.set(remoteData, forKey: "remotes")
    }
    
    func printSettings() {
        print("\tipRoku=\(self.ipRoku)")
        print("\tkeyboardMode=\(self.keyboardMode)")
        print("\tremotes=\(self.remotes)")
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
            let res = Settings(ipRoku:          defaults.string(forKey: "ipRoku") ?? Constants.DEFAULT_SETTINGS.ipRoku,
                               keyboardMode:    KeyboardMode(rawValue: defaults.string(forKey: "keyboardMode") ?? Constants.DEFAULT_SETTINGS.keyboardMode.rawValue)!,
                               remotes: defaults.stringArray(forKey: "remotes")?.map {
                                    try? JSONDecoder().decode(RemoteData.self, from: $0.data(using: .utf8)!)
                               } as? [RemoteData] ?? Constants.DEFAULT_SETTINGS.remotes,
                               refreshToken:    defaults.string(forKey: "refreshToken"))
            print("loaded=", res.ipRoku)
            //            res.printSettings()
            return res
        }
    }
}
