//
//  ViewController.swift
//  OSCServerTest
//
//  Created by Devin Roth on 2018-12-02.
//  Copyright © 2018 Devin Roth. All rights reserved.
//

import UIKit
import Network
import SwiftOSC


class ViewController: UIViewController, OSCDelegate {
    
    @IBOutlet weak var hostTextField: UITextField!
    @IBOutlet weak var portTextField: UITextField!
    @IBOutlet weak var integerStepper: UIStepper!
    @IBOutlet weak var floatSlider: UISlider!
    @IBOutlet weak var booleanSwitch: UISwitch!
    @IBOutlet weak var impulseButton: UIButton!
    @IBOutlet weak var stringTextField: UITextField!

    //Variables
    var host = "127.0.0.1"
    var port: UInt16 = 8080
    
    // Setup Client. Change address from localhost if needed.
    var client = OSCClient(host: "127.0.0.1", port: 8080)
    var address = OSCAddressPattern("/")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        client.delegate = self
        
        hostTextField.text = host
        portTextField.text = String(port)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeHost(_ sender: UITextField) {
        if let text = sender.text{
            if host != text && sender.text != "" {
                host = text
                client = OSCClient(host: NWEndpoint.Host(host), port: NWEndpoint.Port(integerLiteral: port))
            }
            hostTextField.text = host
        }
    }
    
    @IBAction func changePort(_ sender: UITextField) {
        if let text = sender.text {
            if let number = UInt16(text) {
                port = number
                client = OSCClient(host: NWEndpoint.Host(host), port: NWEndpoint.Port(integerLiteral: port))
            }
            portTextField.text = String(port)
        }
    }
    
    @IBAction func sendInteger(_ sender: UIStepper) {
        let message = OSCMessage(address, Int(sender.value))
        client.send(message)
    }
    
    @IBAction func sendFloat(_ sender: UISlider) {
        let message = OSCMessage(address, sender.value)
        client.send(message)
    }
    
    @IBAction func sendBoolean(_ sender: UISwitch) {
        let message = OSCMessage(address, sender.isOn)
        client.send(message)
    }
    
    @IBAction func sendImpulse(_ sender: UIButton) {
        let message = OSCMessage(address, impulse)
        client.send(message)
    }
    
    @IBAction func sendString(_ sender: UITextField) {
        let message = OSCMessage(address, sender.text)
        client.send(message)
    }
    
    //add osc data from notification
    //add osc data from notification
    func didReceive(_ message: OSCMessage) {
        
        if message.address.matches(OSCAddress("/")){
            for argument in message.arguments {
                
                if let int = argument as? Int {
                    integerStepper.value = Double(int)
                }
                if let float = argument as? Float {
                    floatSlider.value = float
                }
                if let bool = argument as? Bool {
                    booleanSwitch.setOn(bool, animated: true)
                }
                if argument is Impulse {
                    let alertController = UIAlertController(title: "BANG", message:
                        "", preferredStyle: UIAlertController.Style.alert)
                    alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default,handler: nil))
                    
                    self.present(alertController, animated: true, completion: nil)
                }
                if let string = argument as? String {
                    stringTextField.text = string
                }
            }
        }
    }
    
}

