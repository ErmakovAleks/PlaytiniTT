//
//  CGFloat+Extensions.swift
//  PlaytiniTT
//
//  Created by Alexander Ermakov on 22.01.2025.
//

import Foundation

extension CGFloat {
    
    static func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UInt32.max))
    }
    
    static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        assert(min < max)
        return CGFloat.random() * (max - min) + min
    }
}
