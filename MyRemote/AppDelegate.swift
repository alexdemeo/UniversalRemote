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

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!
    var button: NSStatusBarButton!
    
    let statusItem: NSStatusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    let popover: NSPopover = NSPopover()
    var settings: Settings = Settings.load()!
    var displaySettingsPane: DisplaySettingsPane = DisplaySettingsPane()
    
    let rightClickMenu: NSMenu = NSMenu()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        rightClickMenu.addItem(NSMenuItem(title: "Quit", action: #selector(quit), keyEquivalent: ""))
        if let button = self.statusItem.button {
            button.image = NSImage(named:NSImage.Name("img_status_bar"))
            button.action = #selector(self.statusBarButtonClicked(sender:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
        self.popover.behavior = .transient
        let hostingController = NSHostingController(rootView: ContentViewMain()
            .environmentObject(self.settings)
            .environmentObject(self.displaySettingsPane)
            .buttonStyle(BorderlessButtonStyle())
        )
        self.popover.contentViewController = hostingController
        NSEvent.addLocalMonitorForEvents(matching: .keyDown, handler: {
            if self.settings.keyboardMode != .off && !self.displaySettingsPane.shown {
                keyDown(keycode: $0.keyCode, mode: self.settings.keyboardMode)
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
    
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    static func instance() -> AppDelegate {
        return NSApplication.shared.delegate as! AppDelegate
    }
    
    static func settings() -> Settings {
        return AppDelegate.instance().settings
    }
}


struct AppDelegate_Previews: PreviewProvider {
    static var settings: Settings = Settings.load()!
    
    static var displaySettingsPane: DisplaySettingsPane = DisplaySettingsPane()
    
    static var previews: some View {
        ContentViewMain()
            .environmentObject(settings)
            .environmentObject(displaySettingsPane)
            .buttonStyle(BorderlessButtonStyle())
    }
}
