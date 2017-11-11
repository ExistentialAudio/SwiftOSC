# SwiftOSC v1.1

SwiftOSC is a Swift Open Sound Control 1.1 client and server framework.




## Installation

### Step 1

Clone or download repository from Github.

### Step 2

Open SwiftOSC.xcworkspace and build SwiftOSC frameworks. 

### Step 3

Embed SwiftOSC into project.



## Quick Start
### OSC Server
#### Step 1
Import SwiftOSC framework into your project
```swift
import SwiftOSC
```
#### Step 2
Create Server
```swift
var server = OSCServer(address: "", port: 8080)
```
#### Step 3
Start server
```
server.start()
```

#### Step 4
Setup server delegate to handle incoming OSC Data
```swift
class OSCHandler: OSCServerDelegate {
    
    func didReceive(_ message: OSCMessage){
        print(message)
    }
}
server.delegate =  OSCHandler()
```
### OSC Client
#### Step 1
Import SwiftOSC framework into your project
```swift
import SwiftOSC
```
#### Step 2
Create client
```swift
var client = OSCClient(address: "localhost", port: 8080)
```
#### Step 3
Create a message
```swift
var message = OSCMessage(
    OSCAddressPattern("/"), 
    100, 
    5.0, 
    "Hello World", 
    Blob(), 
    true, 
    false, 
    nil, 
    impulse, 
    Timetag(1)
)
```
#### Step 4
Send message
```swift
client.send(message)
```
## About

[Devin Roth](http://devinrothmusic.com) is a composer and programmer. When not composing, teaching, or being a dad, Devin attempts to make his life more efficient by writing programs.

For additional information on Open Sound Control visit http://opensoundcontrol.org/.
