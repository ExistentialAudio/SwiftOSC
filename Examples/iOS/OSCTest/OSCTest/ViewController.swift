//
//  ViewController.swift
//  OSCTest
//
//  Created by Devin Roth on 2018-12-13.
//  Copyright © 2018 Devin Roth. All rights reserved.
//

import UIKit
import Network
import SwiftOSC


class ViewController: UIViewController, OSCDelegate, UITextFieldDelegate {
    
    var defaults = UserDefaults.standard
    
    @IBOutlet weak var clientHostTextField: UITextField!
    @IBOutlet weak var clientPortTextField: UITextField!
    @IBOutlet weak var destinationAddressPatternTextField: UITextField!
    @IBOutlet weak var serverPortTextField: UITextField!
    @IBOutlet weak var localAddressPathTextField: UITextField!
    @IBOutlet weak var stringTextField: UITextField!
    @IBOutlet weak var integerSegmentedControl: UISegmentedControl!
    @IBOutlet weak var floatSlider: UISlider!
    @IBOutlet weak var booleanSwitch: UISwitch!
    @IBOutlet weak var impulseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set initial values
        clientHostTextField.text = clientHost
        clientPortTextField.text = String(clientPort)
        destinationAddressPatternTextField.text = destinationAddressPattern.string
        serverPortTextField.text = String(serverPort)
        localAddressPathTextField.text = localAddressPath.string
        
        // setup delegates
        server?.delegate = self
        clientHostTextField.delegate = self
        clientPortTextField.delegate = self
        destinationAddressPatternTextField.delegate = self
        serverPortTextField.delegate = self
        localAddressPathTextField.delegate = self
        stringTextField.delegate = self
        
        
        // hide keyboard by tapping
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }

    // hide keyboard when user hits return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    
    
    @IBAction func changeClientHost(_ sender: UITextField) {
        if let host = sender.text{
            
            if (client?.change(host: host))! {
                clientHost = host
                defaults.set(clientHost, forKey: "clientHost")
                clientHostTextField.text = clientHost
            }
        }
    }
    
    @IBAction func changeClientPort(_ sender: UITextField) {
        if let text = sender.text {
            if let port = Int(text) {
                if (client?.change(port: port))! {
                    clientPort = port
                    defaults.set(clientPort, forKey: "clientPort")
                    clientPortTextField.text = String(clientPort)
                }
            }
        }
    }
    
    @IBAction func changeServerPort(_ sender: UITextField) {
        if let text = sender.text {
            if let port = Int(text) {
                if (server?.change(port: port))! {
                    serverPort = port
                    defaults.set(serverPort, forKey: "serverPort")
                    serverPortTextField.text = String(serverPort)
                }
            }
        }
    }
    
    @IBAction func changeDestinationAddressPattern(_ sender: UITextField) {
        if let text = sender.text {
            destinationAddressPattern = OSCAddressPattern(text)
            defaults.set(destinationAddressPattern.string, forKey: "destinationAddressPattern")
        }
        destinationAddressPatternTextField.text = destinationAddressPattern.string
    }
    
    @IBAction func changeLocalAddressPath(_ sender: UITextField) {
        if let text = sender.text {
            localAddressPath = OSCAddress(text)
            defaults.set(localAddressPath.string, forKey: "localAddressPath")
        }
        localAddressPathTextField.text = localAddressPath.string
    }
    
    
    @IBAction func sendString(_ sender: UITextField) {
        let message = OSCMessage(destinationAddressPattern, sender.text)
        client?.send(message)
    }
    @IBAction func sendInteger(_ sender: UISegmentedControl) {
        let message = OSCMessage(destinationAddressPattern, sender.selectedSegmentIndex)
        client?.send(message)
    }
    @IBAction func sendFloat(_ sender: UISlider) {
        let message = OSCMessage(destinationAddressPattern, sender.value)
        client?.send(message)
    }
    @IBAction func sendBoolean(_ sender: UISwitch) {
        let message = OSCMessage(destinationAddressPattern, sender.isOn)
        client?.send(message)
    }
    @IBAction func sendImpulse(_ sender: UIButton) {
        let message = OSCMessage(destinationAddressPattern, impulse)
        client?.send(message)
    }
    
    func didReceive(_ message: OSCMessage) {
        
        if message.address.matches(localAddressPath){
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

