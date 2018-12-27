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
            
            print("Invalid Hostname: No empty strings allowed.")
            return nil
            
        }
        if port > 65535 && port >= 0{
            print("Invalid Port: Out of range.")
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
            
            print("Invalid Hostname: No empty strings allowed")
            return false
            
        } else if port > 65535 && port >= 0{
            print("Invalid Port: Out of range.")
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
            print("Invalid Hostname: No empty strings allowed")
            return false
        }
    }
    
    public func change(port: Int)->Bool {
        
        // check port range
        if port > 65535 && port >= 0{
            print("Invalid Port: Out of range.")
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
                print("SwiftOSC Client is ready. \(String(describing: self?.connection))")
            case .failed(let error):
                print("SwiftOSC Client failed with error \(error)")
                print("SWiftOSC Client is restarting.")
                self?.setupConnection()
            case .cancelled:
                print("SwiftOSC Client connection cancelled.")
            case .waiting(let error):
                print("SwiftOSC Client waiting with error \(error)")
            case .preparing:
                print("SwiftOSC Client preparing")
            case .setup:
                print("SwiftOSC Client setup")
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
    public func restart() {
        // destroy connection and listener
        connection?.forceCancel()

        
        // setup new listener
        setupConnection()
    }
    
    deinit {
        print("deinit client")
    }
}
