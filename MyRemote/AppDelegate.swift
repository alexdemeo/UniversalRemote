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
        AppDelegate.instance.netAsync(url: "\(AppDelegate.settings.rokuBaseURL)/query/apps", method: "GET")
    }
    
    func updateFor(array: [RemoteButton]) {
        self.array = array
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
    var latestRequest: Request = Request()
    var latestResponse: Response = Response()
    var rokuChannelButtons: ObservedRokuButtons = ObservedRokuButtons()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        rightClickMenu.addItem(NSMenuItem(title: "Quit", action: #selector(quit), keyEquivalent: ""))
        if let button = self.statusItem.button {
            button.image = NSImage(named:NSImage.Name("img_status_bar"))
            button.action = #selector(self.statusBarButtonClicked(sender:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
        self.popover.behavior = .transient
        self.rokuChannelButtons.sendRefreshRequest()
        let hostingController = NSHostingController(rootView:
            ContentViewMain()
                .environmentObject(self.settings)
                .environmentObject(self.displaySettingsPane)
                .environmentObject(self.latestRequest)
                .environmentObject(self.latestResponse)
                .environmentObject(self.rokuChannelButtons)
                .buttonStyle(BorderlessButtonStyle()))
        
        self.popover.contentViewController = hostingController
        NSEvent.addLocalMonitorForEvents(matching: .keyDown, handler: {
            if self.settings.keyboardMode != .off && !self.displaySettingsPane.shown {
                keyDown(keycode: $0.keyCode,
                        mode: self.settings.keyboardMode,
                        shiftDown: $0.modifierFlags.intersection(.deviceIndependentFlagsMask).contains(.shift))
                return nil
            }
            return $0
        })
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
    
    func netAsync(url: String, method: String) {
        print("net(url: \(url), method: \(method))")
        var req = URLRequest(url: URL(string: url)!)
        req.httpMethod = method
        let task = URLSession.shared.dataTask(with: req) { data, response, error in
            DispatchQueue.main.async {
                self.latestRequest.request = req // this is here so status update changes on reply
                self.latestResponse.data = data
                self.latestResponse.response = response as? HTTPURLResponse
                self.latestResponse.error = error
                guard let endpoint = AppDelegate.sanitizeURL(url: url) else {
                    return
                }
                guard let response = self.latestResponse.response else {
                    return
                }
                self.handleAsyncRokuResponseFrom(endpoint: endpoint, withResponse: response)
                print("Result from: \(url) statusCode: \(self.latestResponse.response?.statusCode ?? -1)")
            }
        }
        task.resume()
    }
    
    func handleAsyncRokuResponseFrom(endpoint e: String, withResponse response: HTTPURLResponse) {
        if !e.matches(for: "^(?i)\\/(keypress)?\\/?volume\\/?(up|down)$").isEmpty
            && response.statusCode == 200 {
            // if it's a volume endpoint
            if e.lowercased().contains("up") {
                self.settings.volume += 1
                print("volume + 1 = \(self.settings.volume)")
            } else if e.lowercased().contains("down") {
                print("volume - 1 = \(self.settings.volume)")
                self.settings.volume -= 1
            }
            
        } else if !e.matches(for: "^/query/apps$").isEmpty {
            var apps: [RokuApp] = []
            if let data = self.latestResponse.data {
                let info = String(data: data, encoding: .utf8)
                apps = info!.matches(for: "<app.*<\\/app>").map({
                    RokuApp(line: $0)
                })
            }
            print("Made buttons for apps:\n\(apps.map({"\t\($0)"}).joined(separator: "\n"))")
            let buttons = apps.map({
                RemoteButton(forType: .roku, symbol: $0.name, endpoint: .launch, command: $0.id, associatedApp: $0)
            })
            self.rokuChannelButtons.updateFor(array: buttons)
        }
    }
    
    func netSync(url: String, method: String) -> (Data?, HTTPURLResponse?, Error?)? {
        let s = DispatchSemaphore(value: 0)
        var req = URLRequest(url: URL(string: url)!)
        req.httpMethod = method
        var result: (Data?, HTTPURLResponse?, Error?) = (nil, nil, nil)
        let task = URLSession.shared.dataTask(with: req) { data, response, error in
            result = (data, response as? HTTPURLResponse, error)
            s.signal()
        }
        task.resume()
        let waitResult = s.wait(timeout: DispatchTime.now() + DispatchTimeInterval.seconds(Constants.ROKU_APP_QUERY_TIMEOUT_SECONDS))
        return waitResult == .success ? result : nil
    }
    
    static var instance: AppDelegate {
        NSApplication.shared.delegate as! AppDelegate
    }
    
    static var settings: Settings {
        AppDelegate.instance.settings
    }
    
    static func sanitizeURL(url: String) -> String? {
        guard let regex = try? NSRegularExpression(pattern: "^http.*[0-9]", options: .caseInsensitive) else {
            return nil
        }
        return regex.stringByReplacingMatches(in: url, options: [], range: NSRange(location: 0, length:  url.count), withTemplate: "")
    }
}


struct AppDelegate_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewMain_Previews.previews
    }
}
