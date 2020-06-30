//
//  AppDelegate.swift
//  MyRemote
//
//  Created by Alex DeMeo on 6/25/20.
//  Copyright © 2020 Alex DeMeo. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var window: NSWindow!
    var button: NSStatusBarButton!
    
    let statusItem: NSStatusItem    = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    let popover: NSPopover          = NSPopover()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let button = self.statusItem.button {
            button.image = NSImage(named:NSImage.Name("img_status_bar"))
            button.action = #selector(togglePopover)
        }
        self.popover.behavior = .transient
        self.popover.contentViewController = NSHostingController(rootView: ContentViewMain()
            .buttonStyle(BorderlessButtonStyle()))
        NSEvent.addLocalMonitorForEvents(matching: .keyDown, handler: { event in
            if Constants.KEYBOARD_DEFAULT_ENABLED {
                keyDown(keycode: event.keyCode)
                return event
            } else {
                return nil
            }
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
}


struct AppDelegate_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewMain()
            .buttonStyle(BorderlessButtonStyle())
    }
}
