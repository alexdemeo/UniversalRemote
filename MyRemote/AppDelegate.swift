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
    
    let statusItem: NSStatusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    let popover: NSPopover = NSPopover()
    
    var settings: Settings = Settings.load()!
    
    var displaySettingsPane: DisplaySettingsPane = DisplaySettingsPane()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let button = self.statusItem.button {
            button.image = NSImage(named:NSImage.Name("img_status_bar"))
            button.action = #selector(self.togglePopover)
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
    
    @objc func togglePopover(_ sender: Any?) {
        if let button = self.statusItem.button {
            if self.popover.isShown {
                self.popover.performClose(sender)
            } else {
                self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            }
        }
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    static func settings() -> Settings {
        return (NSApplication.shared.delegate as! AppDelegate).settings
    }
}


struct AppDelegate_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewMain()
            .buttonStyle(BorderlessButtonStyle())
    }
}
