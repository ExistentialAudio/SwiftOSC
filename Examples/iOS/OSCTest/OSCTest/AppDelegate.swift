//
//  AppDelegate.swift
//  OSCTest
//
//  Created by Devin Roth on 2018-12-13.
//  Copyright © 2018 Devin Roth. All rights reserved.
//

import UIKit
import SwiftOSC

// Client Setup
var clientHost = "127.0.0.1"
var clientPort = 8080
var client: OSCClient?
var destinationAddressPattern = OSCAddressPattern("/")

// Server Setup
var serverPort = 8080
var server: OSCServer?
var localAddressPath = OSCAddress("/")

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var defaults = UserDefaults.standard

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // get the user defaults
        if let host = defaults.string(forKey: "clientHost") {
            clientHost = host
        }
        if defaults.integer(forKey: "clientPort") != 0 {
            clientPort = defaults.integer(forKey: "clientPort")
        }
        if let addressPattern = defaults.string(forKey: "destinationAddressPattern") {
            destinationAddressPattern = OSCAddressPattern(addressPattern)
        }
        if defaults.integer(forKey: "serverPort") != 0 {
            serverPort = defaults.integer(forKey: "serverPort")
        }
        if let addressPath = defaults.string(forKey: "localAddressPath") {
            localAddressPath = OSCAddress(addressPath)
        }
        
        // setup osc client and server
        client = OSCClient(host: clientHost, port: clientPort)
        server = OSCServer(port: serverPort)
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        // setup osc client and server
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        // restart client. Client doesn't seem to reconnect to the network after being disconnected.
        client?.restart()
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

