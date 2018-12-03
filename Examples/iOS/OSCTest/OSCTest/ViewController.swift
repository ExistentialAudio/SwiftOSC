//
//  ViewController.swift
//  OSCTest
//
//  Created by Devin Roth on 2017-11-10.
//  Copyright © 2017 Devin Roth. All rights reserved.
//

import UIKit
import Network

//import framework
import SwiftOSC



class ViewController: UIViewController, OSCDelegate {
    
    //Variables
    var host = NWEndpoint.Host("localhost")
    var port = NWEndpoint.Port(integerLiteral: 8080)
    var text = ""
    
    // Setup Client. Change address from localhost if needed.
    var client = OSCClient(host: "localhost", port: 8080)
    var address = OSCAddressPattern("/")\
    
    var clientDelegate = self

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Connect UI and send OSC message
    @IBAction func ipAddressTextField(_ sender: UITextField) {
        
        if let text = sender.text {
            host = NWEndpoint.Host(text)
            client = OSCClient(host: host, port: port)
        }
    }
    
    @IBAction func portTextField(_ sender: UITextField) {
        
        if let text = sender.text {
            if let number = UInt16(text) {
                port = NWEndpoint.Port(integerLiteral: number)
                client = OSCClient(host: host, port: port)
            }
        }
    }
    
    @IBAction func addressPatternTextField(_ sender: UITextField) {
        
        if let text = sender.text {
            address = OSCAddressPattern(text)
        }
    }
    
    @IBAction func stepper(_ sender: UIStepper) {
        let message = OSCMessage(address, Int(sender.value))
        client.send(message)
    }
    
    @IBAction func slider(_ sender: UISlider) {
        let message = OSCMessage(address, sender.value)
        client.send(message)
    }
    
    @IBAction func switcher(_ sender: UISwitch) {
        let message = OSCMessage(address, sender.isOn)
        client.send(message)
    }
    
    @IBAction func impulse(_ sender: UIButton) {
        let message = OSCMessage(address)
        client.send(message)
    }

    @IBAction func text(_ sender: UITextField) {

        text = sender.text!
    }
    
    @IBAction func sendText(_ sender: UIButton) {
        let message = OSCMessage(address, text)
        client.send(message)
        print("Client Sent: " message)
    }
    
    //add osc data from notification
    func didReceive(_ message: OSCMessage) {
        print("Client Received: " message)
    }
    
}

