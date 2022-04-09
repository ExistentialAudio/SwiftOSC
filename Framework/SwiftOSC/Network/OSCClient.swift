//
//  OSCClient.swift
//  SwiftOSC
//
//  Created by Devin Roth on 6/26/16.
//  Copyright © 2019 Devin Roth Music. All rights reserved.
//

import Foundation
import Network

public class OSCClient {

    public var connection: NWConnection? // Access Control: changed 'var connection: NWConnection?' to public.
    public private(set) var ready: Bool = false
    var queue: DispatchQueue

    public private(set) var host: NWEndpoint.Host
    public private(set) var port: NWEndpoint.Port

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

    func setupConnection(){

        // create the connection
        connection = NWConnection(host: host, port: port, using: .udp)

        // setup state update handler
        connection?.stateUpdateHandler = { [weak self] (newState) in
            switch newState {
            case .ready:
                self?.ready = true
                NSLog("SwiftOSC Client is ready. \(String(describing: self?.connection))")
            case .failed(let error):
                self?.ready = false
                NSLog("SwiftOSC Client failed with error \(error)")
                NSLog("SWiftOSC Client is restarting.")
                self?.setupConnection()
            case .cancelled:
                NSLog("SWiftOSC Client cancelled.")
                self?.ready = false
                break
            case .waiting(let error):
                self?.ready = false
                NSLog("SwiftOSC Client waiting with error \(error)")
            case .preparing:
                NSLog("SWiftOSC Client is preparing.")
                self?.ready = false
                break
            case .setup:
                NSLog("SWiftOSC Client is setting up.")
                self?.ready = false
                break
            }
        }

        // start the connection
        connection?.start(queue: queue)
    }

    public func send(_ element: OSCElement){

        let data = element.oscData
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
