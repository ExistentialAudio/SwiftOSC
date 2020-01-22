import Foundation





/// For sending OSC messages to another OSC device on the network, or to another application on the current machine.
@objc open class OSCClient: NSObject {
    
    /// Returns the current address, or sets the address messages will be sent to.
    open var address: String {
        didSet {
            _ = client.close()
            client = UDPClient(addr: address, port: port)
        }
    }
    
    /// Returns the current port, or sets the port messages will be sent to.
    open var port: Int {
        didSet {
            _ = client.close()
            client = UDPClient(addr: address, port: port)
        }
    }

    var client: UDPClient
        
    
    /**
     *Creates a new OSCClient*
     
    - Parameters:
       - address: Could be an IP address, or just "localhost" for sending internally in your computer
       - port: Must be a vaild port that's not being used.
    */
    public init(address: String, port: Int) {
        self.address = address
        self.port = port
        client = UDPClient(addr: address, port: port)
        client.enableBroadcast()
    }

    
    /**
     Send a message to current address and port
     
     - Important:
        If the OSCClient is not connected to a valid address and port, this method will not throw an error. You are responsible for managing
        a vaild connection.
    
     - Parameters:
       - element: An OSCElement is an abstract protocol inherited by OSCMessage and OSCBundle.
     
     ~~~
     // Here's an example of its usage
     let message = OSCMessage(someAddress, 4.14)
     myClient.send(message)
     ~~~
    */
    open func send(_ element: OSCElement) {
        let data = element.data
        
        if data.count > 9216 {
            print("OSCPacket is too large. Must be smaller than 9200 bytes")
        } else {
            _ = client.send(data:data)
        }
    }
    
    
    /// Closes the port when deinitialized.
    deinit {
        _ = client.close()
    }
}
