//
//  ViewController.swift
//  OSCClientTest
//
//  Created by Devin Roth on 2018-12-02.
//  Copyright © 2018 Devin Roth. All rights reserved.
//

import UIKit
import Network
import SwiftOSC


class ViewController: UIViewController, OSCDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var hostTextField: UITextField!
    @IBOutlet weak var portTextField: UITextField!
    @IBOutlet weak var addressPatternTextField: UITextField!
    @IBOutlet weak var addressPathTextField: UITextField!
    @IBOutlet weak var integerSegmentedControl: UISegmentedControl!
    @IBOutlet weak var floatSlider: UISlider!
    @IBOutlet weak var booleanSwitch: UISwitch!
    @IBOutlet weak var impulseButton: UIButton!
    @IBOutlet weak var stringTextField: UITextField!

    //Variables
    var host = "127.0.0.1"
    var port: UInt16 = 8080
    
    // Setup Client. Change address from localhost if needed.
    var client = OSCClient(host: "127.0.0.1", port: 8080)
    var addressPattern = OSCAddressPattern("/")
    var addressPath = OSCAddress("/")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup delegates
        client.delegate = self
        hostTextField.delegate = self
        portTextField.delegate = self
        addressPatternTextField.delegate = self
        addressPathTextField.delegate = self
        stringTextField.delegate = self
        
        // setup initial values
        hostTextField.text = host
        portTextField.text = String(port)
        addressPatternTextField.text = addressPattern.string
        addressPathTextField.text = addressPath.string
        
        // hide keyboard by tapping
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
    
    // hide keyboard when user hits return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    
    
    @IBAction func changeHost(_ sender: UITextField) {
        if let text = sender.text{
            if host != text && sender.text != "" {
                host = text
                client.host = NWEndpoint.Host(host)
            }
            hostTextField.text = host
        }
    }
    
    @IBAction func changePort(_ sender: UITextField) {
        if let text = sender.text {
            if let number = UInt16(text) {
                port = number
                client.port = NWEndpoint.Port(integerLiteral: port)
            }
            portTextField.text = String(port)
        }
    }
    
    @IBAction func changeAddressPattern(_ sender: UITextField) {
        if let text = sender.text {
            addressPattern = OSCAddressPattern(text)
        }
        addressPatternTextField.text = addressPattern.string
    }
    
    @IBAction func changeAddressPath(_ sender: UITextField) {
        if let text = sender.text {
            addressPath = OSCAddress(text)
        }
        addressPathTextField.text = addressPath.string
    }
    
    
    @IBAction func sendString(_ sender: UITextField) {
        let message = OSCMessage(addressPattern, sender.text)
        client.send(message)
    }
    @IBAction func sendInteger(_ sender: UISegmentedControl) {
        let message = OSCMessage(addressPattern, sender.selectedSegmentIndex)
        client.send(message)
    }
    @IBAction func sendFloat(_ sender: UISlider) {
        let message = OSCMessage(addressPattern, sender.value)
        client.send(message)
    }
    @IBAction func sendBoolean(_ sender: UISwitch) {
        let message = OSCMessage(addressPattern, sender.isOn)
        client.send(message)
    }
    @IBAction func sendImpulse(_ sender: UIButton) {
        let message = OSCMessage(addressPattern, impulse)
        client.send(message)
    }
    
    //add osc data from notification
    //add osc data from notification
    func didReceive(_ message: OSCMessage) {
        
        if message.address.matches(addressPath){
            for argument in message.arguments {
                
                if let int = argument as? Int {
                    integerSegmentedControl.selectedSegmentIndex = int
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

