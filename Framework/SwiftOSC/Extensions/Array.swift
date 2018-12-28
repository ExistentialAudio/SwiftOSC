//
//  Array.swift
//  SwiftOSC
//
//  Created by Devin Roth on 2018-12-28.
//  Copyright © 2018 Devin Roth. All rights reserved.
//

import Foundation


extension Array {
    public subscript (safe index: UInt) -> Element? {
        return Int(index) < count ? self[Int(index)] : nil
    }
}
