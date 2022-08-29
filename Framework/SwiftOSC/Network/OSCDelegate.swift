//
//  OSCDelegate.swift
//  SwiftOSC
//
//  Created by Devin Roth on 2018-12-01.
//  Copyright © 2019 Devin Roth. All rights reserved.
//

import Foundation

public protocol OSCDelegate: AnyObject {
    func didReceive(_ data: Data)
    func didReceive(_ bundle: OSCBundle)
    func didReceive(_ message: OSCMessage)
}
extension OSCDelegate {
    public func didReceive(_ data: Data){}
    public func didReceive(_ bundle: OSCBundle){}
    public func didReceive(_ message: OSCMessage){}
}
