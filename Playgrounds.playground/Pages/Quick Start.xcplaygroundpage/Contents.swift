import Foundation
import PlaygroundSupport
/*:

# SwiftOSC 
A simple OSC Client and Server written in Swift.
 
 */
//: ## Quick Start - Server
//: ### Step 1
//: Import SwiftOSC
import SwiftOSC

//: ### Step 2
//: Create Server
var server = OSCServer(address: "", port: 9000)

//: ### Step 3
//: Start Server
server.start()

//: ### Step 4
//: Setup server delegate
class OSCHandler: OSCServerDelegate {
    
    func didReceive(_ message: OSCMessage){
        print(message)
    }
}
server.delegate =  OSCHandler()

//: ## Quick Start - Client
//: ### Step 1
//: Import SwiftOSC
import SwiftOSC

//: ### Step 2
//: Create client
var client = OSCClient(address: "localhost", port: 9000)

//: ### Step 3
//: Create a message
var message = OSCMessage(OSCAddressPattern("/test"), 110, 5.0, "Hello World", Blob(), true, false, nil, impulse, Timetag(1))

//: Create a bundle
// If the server fully supports timetags, like SwiftOSC, the bundle will be delivered at the correct time.
var bundle = OSCBundle(Timetag(secondsSinceNow: 5.0), message)

//: ### Step 4
//: Send message
client.send(message)
//: Send message
client.send(bundle)

//:Keeps playground running in order to send and receive OSC Data
PlaygroundPage.current.needsIndefiniteExecution = true

