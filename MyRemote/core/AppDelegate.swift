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
    @Published var array: [RemoteButton] = []
    @Published var buttonToImg: [String: Data?] = [:]

    func requestButtons() {
        AppDelegate.instance.networkManager.async(url: "\(AppDelegate.instance.settings.rokuBaseURL)/query/apps", method: "GET", header: nil, body: nil) { data, response, error in
            print("ObservedRokuButtons.requestButtons()")
            var apps: [RokuApp] = []
            if let data = data {
                let info = String(data: data, encoding: .utf8)
                apps = info!.matches(for: "<app.*<\\/app>").map({
                    RokuApp(line: $0)
                })
            }
            let buttons = apps.map({
                RemoteButton(forType: .roku, symbol: $0.name, endpoint: .launch, command: $0.id, associatedApp: $0)
            })
            self.array = buttons
            
            self.array.forEach({ remoteButton in
                let id = remoteButton.associatedApp!.id
                AppDelegate.instance.networkManager.async(url: "\(AppDelegate.instance.settings.rokuBaseURL)/query/icon/\(id)", method: "GET", header: nil, body: nil) { data, response, error in
                    guard let response = response else {
                        self.buttonToImg[id] = nil
                        return
                    }
                    if response.statusCode == 200 {
                        self.buttonToImg[id] = data!
                    }
                }
            })
        }
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
    var networkManager: NetworkManager = NetworkManager()
    var rokuChannelButtons: ObservedRokuButtons = ObservedRokuButtons()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        rightClickMenu.addItem(NSMenuItem(title: "Quit", action: #selector(quit), keyEquivalent: ""))
        if let button = self.statusItem.button {
            button.image = NSImage(named:NSImage.Name("img_status_bar"))
            button.action = #selector(self.statusBarButtonClicked(sender:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
        self.popover.behavior = .transient
        if settings.remotes.contains(where: { $0.title == "Roku" && $0.enabled}) {
            self.rokuChannelButtons.requestButtons()
        }
        let hostingController = NSHostingController(rootView:
                                                        ContentViewMain()
                                                        .environmentObject(self.settings)
                                                        .environmentObject(self.displaySettingsPane)
                                                        .environmentObject(self.networkManager.latestRequest)
                                                        .environmentObject(self.networkManager.latestResponse)
                                                        .environmentObject(self.rokuChannelButtons)
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
    
    func handleAsyncRokuResponseFrom(endpoint e: String, withResponse response: HTTPURLResponse) {
        print("Result from endpoint: \(e) statusCode: \(self.networkManager.latestResponse.response?.statusCode ?? -1)")

        if !e.matches(for: "^(?i)\\/(keypress)?\\/?volume\\/?(up|down)$").isEmpty
            && response.statusCode == 200 {
            // if it's a volume endpoint
            if e.lowercased().contains("up") {
            } else if e.lowercased().contains("down") {
            } else if e.lowercased().contains("Lit_") {
//                let char = e.split(separator: "_")[1]
//                self.updateTextFieldFor(character: String(char))
            }
        } else if !e.matches(for: "^/query/apps$").isEmpty {
//            self.rokuChannelButtons.set()
        }
    }
}


struct AppDelegate_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewMain_Previews.previews
    }
}
