//
//  ViewController.swift
//  OSCTest
//
//  Created by Devin Roth on 2017-11-10.
//  Copyright © 2017 Devin Roth. All rights reserved.
//

import UIKit

//import framework
import SwiftOSC

let address = OSCAddressPattern("/test")

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Connect UI and send OSC message
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
        
        let message = OSCMessage(address, sender.text!)
        client.send(message)
    }
    
}

