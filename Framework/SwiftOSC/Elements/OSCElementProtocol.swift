//
//  OSCElementProtocol.swift
//  SwiftOSC
//
//  Created by Devin Roth on 6/26/16.
//  Copyright © 2019 Devin Roth Music. All rights reserved.
//

import Foundation

public protocol OSCElement {
    var oscData: Data { get }
}
