import Foundation
import Network

public class OSCClient: OSCNetwork {
    
    public var delegate: OSCDelegate?
    
    var connection: NWConnection?
    var queue: DispatchQueue
    
    public var host: NWEndpoint.Host {
        didSet {
            connection?.cancel()
            setupConnection()
        }
    }
    public var port: NWEndpoint.Port {
        didSet {
            connection?.cancel()
            setupConnection()
        }
    }
    
    public init(host: NWEndpoint.Host, port: NWEndpoint.Port) {
        self.host = host
        self.port = port
        
        queue = DispatchQueue(label: "SwiftOSC Client")
        
        setupConnection()
    }
    
    func setupConnection(){
        
        // create the connection
        connection = NWConnection(host: host, port: port, using: .udp)
        
        // setup state update handler
        connection?.stateUpdateHandler = { (newState) in
            switch newState {
            case .ready:
                print("SwiftOSC Client is ready. \(String(describing: self.connection))")
                self.receive()
            case .failed(let error):
                print("SwiftOSC Client failed with error \(error)")
                print("SWiftOSC Client is restarting.")
                self.setupConnection()
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
        
        let data = element.data
        connection?.send(content: data, completion: .contentProcessed({ (error) in
            if let error = error {
                print("Send error: \(error)")
            }
        }))
    }
}
