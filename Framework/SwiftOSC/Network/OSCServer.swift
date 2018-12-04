import Foundation
import Network

public class OSCServer: OSCNetwork {
    
    public var delegate: OSCDelegate?
    
    var connection: NWConnection?
    
    var listener: NWListener
    var queue: DispatchQueue
    var connected: Bool = false
    
    public init(port: NWEndpoint.Port) {
        queue = DispatchQueue(label: "SwiftOSC Server")
        
        // create the listener
        listener = try! NWListener(using: .udp, on: port)
        
        // handle incoming connections
        listener.newConnectionHandler = { [weak self] (newConnection) in
            if let strongSelf = self {
                print("New Connection")
                strongSelf.connection = newConnection
                strongSelf.connection?.start(queue: strongSelf.queue)
                strongSelf.receive()
            }
        }
        
        // Handle listener state changes
        listener.stateUpdateHandler = { [weak self] (newState) in
            switch newState {
            case .ready:
                print("Listening on port \(String(describing: self?.listener.port))")
            case .failed(let error):
                print("Listener failed with error \(error)")
            default:
                break
            }
        }
        
        // start the listener
        listener.start(queue: queue)
    }
    
    public func send(_ element: OSCElement){
        var data = element.data
        if data.count > 9216 {
            print("OSCPacket is too large. Must be smaller than 9200 bytes.")
        } else {
            if let connection = connection {
                connection.send(content: data, completion: .contentProcessed({ (error) in
                    if let error = error {
                        print("Send error: \(error)")
                    }
                }))
            } else {
                print("No clients connected to server")
            }

        }
    }
    
    deinit {
        connection?.cancel()
    }
}
