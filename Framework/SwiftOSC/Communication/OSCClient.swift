import Foundation

@objc public class OSCClient: NSObject {
    public var address: String {
        didSet {
            _ = client.close()
            client = UDPClient(addr: address, port: port)
        }
    }
    public var port: Int {
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
    public func send(_ element: OSCElement){
        var data = element.data
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
