//
//  ViewController.swift
//  OSCMonitor
//
//  Created by Devin Roth on 7/15/16.
//  Copyright © 2016 Devin Roth Music. All rights reserved.
//

import Cocoa
import SwiftOSC

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //set view to receive notifications from server
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(printOSCMessage),
            name: OSCServer.didReceiveMessage,
            object: nil
        )
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    //print osc data from notification
    func printOSCMessage(notification: Notification) {
        print(notification.object as! OSCMessage)
    }

}

