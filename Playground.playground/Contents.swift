/*:

# SwiftOSC 
A simple OSC Client and Server for Swift 3.0
 
 */
import Foundation
import PlaygroundSupport

//: ## Step 1
//: Import SwiftOSC
import SwiftOSC

//: ## Step 2
//: Setup client
var client = OSCClient(address: "localhost", port: 8080)

//: ## Step 3
//: Setup Server
var server = OSCServer(address: "", port: 8080)
server.start()

//: ## Step 4
//: Setup to receive notifications from Server
NotificationCenter.default.addObserver(forName: OSCServer.didReceiveMessage, object: nil, queue: nil, using:
    { (notification: Notification) in
        let message = notification.object as! OSCMessage
        print(message)
    }
)

//: ## Step 5
//: Create a message
var message = OSCMessage(OSCAddressPattern("/"), 100, 5.0, "Hello World", Blob(), true, false, nil, impulse, Timetag(1))

//: ## Step 6
//: Send message
client.send(message)

//: ## Done
//:Keeps playground running in order to send and receive OSC Data
PlaygroundPage.current.needsIndefiniteExecution = true