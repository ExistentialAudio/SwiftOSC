import Foundation
import Network

public class OSCClient {
    
    var connection: NWConnection?
    var queue: DispatchQueue
    
    var host: NWEndpoint.Host
    var port: NWEndpoint.Port
    
    public init?(host: String, port: Int) {
        
        // check if string is empty
        if host == "" {
            
            NSLog("Invalid Hostname: No empty strings allowed.")
            return nil
            
        }
        if port > 65535 && port >= 0{
            NSLog("Invalid Port: Out of range.")
            return nil
        }
        
        self.host = NWEndpoint.Host(host)
        self.port = NWEndpoint.Port(integerLiteral: UInt16(port))
        
        queue = DispatchQueue(label: "SwiftOSC Client")
        setupConnection()
    }
    
    public func change(host: String, port: Int)->Bool{
        
        // check if string is empty
        if host == "" {
            
            NSLog("Invalid Hostname: No empty strings allowed")
            return false
            
        } else if port > 65535 && port >= 0{
            NSLog("Invalid Port: Out of range.")
            return false
            
        } else {
            
            self.host = NWEndpoint.Host(host)
            self.port = NWEndpoint.Port(integerLiteral: UInt16(port))
            
            connection?.cancel()
            setupConnection()
            return true
            
        }
    }
    
    public func change(host: String)->Bool {
        if host != "" {
            self.host = NWEndpoint.Host(host)
            
            connection?.cancel()
            setupConnection()
            return true
            
        } else {
            NSLog("Invalid Hostname: No empty strings allowed")
            return false
        }
    }
    
    public func change(port: Int)->Bool {
        
        // check port range
        if port > 65535 && port >= 0{
            NSLog("Invalid Port: Out of range.")
            return false
        }
        
        self.port = NWEndpoint.Port(integerLiteral: UInt16(port))
        
        connection?.cancel()
        setupConnection()
        return true
    }
    
    func setupConnection(){
        
        // create the connection
        connection = NWConnection(host: host, port: port, using: .udp)
        
        // setup state update handler
        connection?.stateUpdateHandler = { [weak self] (newState) in
            switch newState {
            case .ready:
                NSLog("SwiftOSC Client is ready. \(String(describing: self?.connection))")
            case .failed(let error):
                NSLog("SwiftOSC Client failed with error \(error)")
                NSLog("SWiftOSC Client is restarting.")
                self?.setupConnection()
            case .cancelled:
                //NSLog("SwiftOSC Client connection cancelled.")
                break
            case .waiting(let error):
                NSLog("SwiftOSC Client waiting with error \(error)")
            case .preparing:
                //NSLog("SwiftOSC Client preparing")
                break
            case .setup:
                //NSLog("SwiftOSC Client setup")
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
                NSLog("Send error: \(error)")
            }
        }))
    }
    public func restart() {
        // destroy connection and listener
        connection?.forceCancel()

        
        // setup new listener
        setupConnection()
    }
}
