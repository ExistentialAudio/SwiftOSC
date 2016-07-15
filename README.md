# SwiftOSC v1.0
SwiftOSC is a OSC client and server 3.0 framework for Swift 3.0. 

## Quick Start

### Step 1
Import SwiftOSC framework into your project
```
import SwiftOSC
```
### Step 2
Setup client
```
var client = OSCClient(address: "localhost", port: 8080)
```
### Step 3
Setup Server
```
var server = OSCServer(address: "", port: 8080)
server.start()
```

### Step 4
Setup to receive notifications from Server
```
NotificationCenter.default.addObserver(forName: OSCServer.didReceiveMessage, object: nil, queue: nil, using:
    { (notification: Notification) in
        let message = notification.object as! OSCMessage
        print(message)
    }
)
```
### Step 5
Create a message
```
var message = OSCMessage(OSCAddressPattern("/"), 100, 5.0, "Hello World", Blob(), true, false, nil, impulse, Timetag(1))
```
### Step 6
Send message
```
client.send(message)
```
## About

[Devin Roth](http://devinrothmusic.com) is a composer and programmer. He has worked on the music for numerous projects including *Hotel Transylvania 2*, *The Book of Life*, *Crazy-Ex Girlfriend*, and *Alvin and the Chipmunks: The Road Chip*. When not composing, teaching, or being a dad, Devin attempts to make his life more efficient by writing programs.


