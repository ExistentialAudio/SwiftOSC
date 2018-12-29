# SwiftOSC v2.0

[![Version](https://img.shields.io/cocoapods/v/SwiftOSC.svg?style=flat)](http://cocoapods.org/pods/SwiftOSC)
[![License](https://img.shields.io/cocoapods/l/SwiftOSC.svg?style=flat)](https://github.com/devinroth/SwiftOSC/blob/master/LICENSE)
[![Platform](https://img.shields.io/cocoapods/p/SwiftOSC.svg?style=flat)](http://cocoapods.org/pods/SwiftOSC)
<img src="https://img.shields.io/badge/in-swift4.2-orange.svg">

SwiftOSC is a Swift Open Sound Control (OSC) 1.1 client and server framework.


## Installation

```
pod 'SwiftOSC', '~> 2.0'
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
var server = OSCServer(port: 8080)
```

#### Step 3
Setup server delegate to handle incoming OSC Data
```swift
class OSCHandler: OSCServerDelegate {
    
    func didReceive(_ message: OSCMessage){
        if let integer = message.arguments[0] as? Int {
            print("Received int \(integer)")
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
Create OSCClient
```swift
var client = OSCClient(host: "localhost", port: 8080)
```
#### Step 3
Create an OSCAddressPattern and  OSCMessage
```swift

var message = OSCMessage(
    OSCAddressPattern("/")!,
    100,
    5.0,
    "Hello World",
    true,
    false,
    nil,
    OSCBlob(),                  // aka Data()
    OSCImpulse(),
    OSCTimetag(1)               // aka UInt64()
)
```
#### Step 4
Send message
```swift
client.send(message)
```
## Known Issues
 - OSCClient loses connection following returning from being in the background. Call client.restart() in this situation.\
 

## About

[Devin Roth](http://devinrothmusic.com) is a composer and programmer. When not composing, teaching, or being a dad, Devin attempts to make his life more efficient by writing programs.

For additional information on Open Sound Control visit http://opensoundcontrol.org/.
