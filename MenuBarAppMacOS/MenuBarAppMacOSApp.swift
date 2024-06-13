//
//  MenuBarAppMacOSApp.swift
//  MenuBarAppMacOS
//
//  Created by Volodymyr Pysarenko on 13.06.2024.
//

import SwiftUI

@main
struct MenuBarAppMacOSApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

//Making it as pure menu bar app in info.plist

//Setting up Menu Bar Icon and Menu Popover area
class AppDelegate: NSObject, ObservableObject, NSApplicationDelegate {
    @Published var statusItem: NSStatusItem?
    @Published var popover = NSPopover()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        setupMacMenu()
    }
    
    func setupMacMenu() {
        //Popover properties
        popover.animates = true
        popover.behavior = .transient
        
        //Linking SwiftUI View
        popover.contentViewController = NSViewController()
        popover.contentViewController?.view = NSHostingView(rootView: Home())
        
        //Making it as key window
        popover.contentViewController?.view.window?.makeKey()
        
        //Setting menu bar icon and action
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let menuButton = statusItem?.button {
            menuButton.image = .init(systemSymbolName: "dollarsign.circle.fill", accessibilityDescription: nil)
            menuButton.action = #selector(menuButtonAction(sender:))
        }
    }
    
    @objc func menuButtonAction(sender: AnyObject) {
        if popover.isShown {
            popover.performClose(sender)
        } else {
            if let menuButton = statusItem?.button {
                popover.show(relativeTo: menuButton.bounds, of: menuButton, preferredEdge: .minY)
            }
        }
    }
}
