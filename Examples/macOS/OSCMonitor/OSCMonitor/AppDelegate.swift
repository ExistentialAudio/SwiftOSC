//
//  AppDelegate.swift
//  OSCMonitor
//
//  Created by Devin Roth on 7/15/16.
//  Copyright © 2016 Devin Roth Music. All rights reserved.
//

import Cocoa
import SwiftOSC

//create OSC server
var server = OSCServer(address: "", port: 8080)

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        server.stop()
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

}

