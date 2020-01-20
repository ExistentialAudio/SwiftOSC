import Foundation

@objc open class OSCClient: NSObject {
    open var address: String {
        didSet {
            _ = client.close()
            client = UDPClient(addr: address, port: port)
        }
    }
    open var port: Int {
        didSet {
            _ = client.close()
            client = UDPClient(addr: address, port: port)
        }
    }
    var client: UDPClient
    
    public init(address: String, port: Int){
        self.address = address
        self.port = port
        client = UDPClient(addr: address, port: port)
        client.enableBroadcast()
    }
    open func send(_ element: OSCElement){
        let data = element.data
        if data.count > 9216 {
            print("OSCPacket is too large. Must be smaller than 9200 bytes")
        } else {
            _ = client.send(data:data)
        }
    }
    deinit {
        _ = client.close()
    }
}
