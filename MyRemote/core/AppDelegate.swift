//
//  AppDelegate.swift
//  MyRemote
//
//  Created by Alex DeMeo on 6/25/20.
//  Copyright © 2020 Alex DeMeo. All rights reserved.
//

import Cocoa
import SwiftUI

class DisplaySettingsPane: ObservableObject {
    @Published var shown: Bool = false
}

class Request: ObservableObject {
    @Published var request: URLRequest? = nil
}

class Response: ObservableObject {
    @Published var data: Data? = nil
    @Published var response: HTTPURLResponse? = nil
    @Published var error: Error? = nil
}

class ObservedRokuButtons: ObservableObject {
    @Published var array = [RemoteButton]()
    
    func sendRefreshRequest() {
        AppDelegate.instance.netAsync(url: "\(AppDelegate.settings.rokuBaseURL)/query/apps", method: "GET", header: nil, body: nil, callback: nil)
    }
    
    func updateFor(array: [RemoteButton]) {
        self.array = array
    }
}

class ObservedCoffeeMachine: ObservableObject {
    @Published var coffeeState: CoffeeState? = nil

    func sendRefreshRequest() {
        AppDelegate.instance.netAsync(url: "\(pi3URL)/status", method: "GET", header: nil, body: nil, callback: {
            data, response, error in
            guard let data = data else {
                return
            }
            let code = String(data: data, encoding: .utf8)
            self.coffeeState = code == "on" ? .on : .off
            print("machine is \(String(describing: code))")
        })
    }
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    let statusItem: NSStatusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    let popover: NSPopover = NSPopover()
    let rightClickMenu: NSMenu = NSMenu()
    
    var window: NSWindow!
    var button: NSStatusBarButton!
    var settings: Settings = Settings.load()!
    var displaySettingsPane: DisplaySettingsPane = DisplaySettingsPane()
    var networkManager: NetworkManager = NetworkManager.shared
    var rokuChannelButtons: ObservedRokuButtons = ObservedRokuButtons()
    var coffeeMachine: ObservedCoffeeMachine = ObservedCoffeeMachine()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        rightClickMenu.addItem(NSMenuItem(title: "Quit", action: #selector(quit), keyEquivalent: ""))
        if let button = self.statusItem.button {
            button.image = NSImage(named:NSImage.Name("img_status_bar"))
            button.action = #selector(self.statusBarButtonClicked(sender:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
        self.popover.behavior = .transient
        if settings.remotes.contains(where: { $0.title == "Roku" && $0.enabled}) {
            self.rokuChannelButtons.sendRefreshRequest()
        }
        if settings.remotes.contains(where: { $0.title == "Home" && $0.enabled}) {
            self.coffeeMachine.sendRefreshRequest()
        }
        let hostingController = NSHostingController(rootView:
                                                        ContentViewMain()
                                                        .environmentObject(self.settings)
                                                        .environmentObject(self.displaySettingsPane)
                                                        .environmentObject(self.networkManager.latestRequest)
                                                        .environmentObject(self.networkManager.latestResponse)
                                                        .environmentObject(self.rokuChannelButtons)
                                                        .environmentObject(self.coffeeMachine)
                                                        .buttonStyle(BorderlessButtonStyle()))
        
        self.popover.contentViewController = hostingController
        NSEvent.addLocalMonitorForEvents(matching: .keyDown, handler: {
            if !self.displaySettingsPane.shown {
                keyDown(keycode: $0.keyCode,
                        mode: self.settings.keyboardMode,
                        shiftDown: $0.modifierFlags.intersection(.deviceIndependentFlagsMask).contains(.shift))
                return nil
            }
            return $0
        })
    }
    
    func application(_ application: NSApplication, open urls: [URL]) {
//        self.spotifyAuth?.browserRedirect(urls: urls)
        SpotifyAuth.shared.onReceiveAuthorizeResponse(urls: urls)
    }
    
    @objc func quit() {
        NSApplication.shared.terminate(self)
    }
    
    @objc func statusBarButtonClicked(sender: NSStatusBarButton) {
        let event = NSApp.currentEvent!
        
        if event.type == .rightMouseUp {
            self.popover.performClose(sender)
            statusItem.menu = rightClickMenu
            statusItem.button?.performClick(nil)
            statusItem.menu = nil
        } else if event.type == .leftMouseUp {
            if popover.isShown {
                popover.performClose(sender)
            } else {
                if let button = statusItem.button {
                    popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
                }
            }
        }
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {}
    
    func netAsync(url: String, method: String, header: [String: String]?, body: [String: String]?, callback: ((Data?,  HTTPURLResponse?, Error?) -> Void)?) {
        self.networkManager.async(url: url, method: method, header: header, body: body, callback: callback)
    }
    
    func netSync(url: String, method: String) -> (Data?, HTTPURLResponse?, Error?)? {
        return self.networkManager.sync(url: url, method: method)
    }
    
    static var instance: AppDelegate {
        NSApplication.shared.delegate as! AppDelegate
    }
    
    static var settings: Settings {
        AppDelegate.instance.settings
    } 
}


struct AppDelegate_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewMain_Previews.previews
    }
}
