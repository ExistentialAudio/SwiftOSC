import Foundation
import Network

public class OSCServer: OSCNetwork {
    
    public var delegate: OSCDelegate?
    
    var listener: NWListener?
    public var port: NWEndpoint.Port {
        didSet {
            // destroy connection and listener
            connection?.forceCancel()
            listener?.cancel()
            
            // setup new listener
            setupListener()
        }
    }
    var queue: DispatchQueue
    var connection: NWConnection?
    
    public init(port: NWEndpoint.Port) {
        self.port = port
        queue = DispatchQueue(label: "SwiftOSC Server")
        
        setupListener()
    }
    
    func setupListener() {
        // create the listener
        listener = try! NWListener(using: .udp, on: port)
        
        // handle incoming connections server will only respond to the latest connection
        listener?.newConnectionHandler = { (newConnection) in
            
            print("New Connection from \(String(describing: newConnection))")
            
            // cancel previous connection
            if self.connection != nil {
                print("Cancelling conecction: \(String(describing: newConnection))")
                self.connection?.cancel()
            }
            
            self.connection = newConnection
            self.connection?.start(queue: self.queue)
            self.receive()
        }
        
        // Handle listener state changes
        listener?.stateUpdateHandler = { [weak self] (newState) in
            switch newState {
            case .ready:
                print("Listening on port \(String(describing: self?.listener?.port))")
            case .failed(let error):
                print("Listener failed with error \(error)")
            case .cancelled:
                print("Listener cancelled")
            default:
                break
            }
        }
        
        // start the listener
        listener?.start(queue: queue)
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
}
