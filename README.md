# SwiftOSC v1.2

[![Version](https://img.shields.io/cocoapods/v/SwiftOSC.svg?style=flat)](http://cocoapods.org/pods/SwiftOSC)
[![License](https://img.shields.io/cocoapods/l/SwiftOSC.svg?style=flat)](https://github.com/devinroth/SwiftOSC/blob/master/LICENSE)
[![Platform](https://img.shields.io/cocoapods/p/SwiftOSC.svg?style=flat)](http://cocoapods.org/pods/SwiftOSC)
<img src="https://img.shields.io/badge/in-swift4.2-orange.svg">

SwiftOSC is a Swift Open Sound Control (OSC) 1.1 client and server framework.




## Installation

```
pod 'SwiftOSC', '~> 1.2'
```

OR

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
        if let integer = message.arguments[0] as Int {
            print("Received int \(integer)"
        } else {
            print(message)
        }
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

## Known Issues
* All OSC messages are delivered immediately. Timetags are ignored.

## About

[Devin Roth](http://devinrothmusic.com) is a composer and programmer. When not composing, teaching, or being a dad, Devin attempts to make his life more efficient by writing programs.

For additional information on Open Sound Control visit http://opensoundcontrol.org/.
