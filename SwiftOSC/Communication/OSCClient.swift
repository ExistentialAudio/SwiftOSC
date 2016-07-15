import Foundation

public class OSCClient {
    public var address: String
    public var port: Int
    
    public init(address: String, port: Int){
        self.address = address
        self.port = port
    }
    public func send(_ element: OSCElement){
        var data = element.data
        if data.count > 9216 {
            print("OSCPacket is too large. Must be smaller than 9200 bytes")
        } else {
            let client = UDPClient(addr: address, port: port)
            _ = client.send(data:data)
            _ = client.close()
        }
    }
}
