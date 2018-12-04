import Foundation
import Network

public class OSCClient: OSCNetwork {
    
    public var delegate: OSCDelegate?
    
    var connection: NWConnection?
    var queue: DispatchQueue
    
    public init(host: NWEndpoint.Host, port: NWEndpoint.Port) {
        queue = DispatchQueue(label: "SwiftOSC Client")
        
        // create the connection
        connection = NWConnection(host: host, port: port, using: .udp)
        
        // setup state update handler
        connection?.stateUpdateHandler = { [weak self] (newState) in
            switch newState {
            case .ready:
                print("SwiftOSC Client is ready.")
                self?.receive()
            case .failed(let error):
                print("SwiftOSC Client failed with error \(error)")
            case .cancelled:
                print("SwiftOSC Client connection cancelled.")
            default:
                break
            }
        }
        
        // start the connection
        connection?.start(queue: queue)
    }
    public func send(_ element: OSCElement){
        var data = element.data
        if data.count > 9216 {
            print("OSCPacket is too large. Must be smaller than 9200 bytes.")
        } else {
            connection?.send(content: data, completion: .contentProcessed({ (error) in
                if let error = error {
                    print("Send error: \(error)")
                    self.connection?.start(queue: self.queue)
                }
            }))
        }
    }
    
    deinit {
        connection?.cancel()
    }
}
