//
//  Constants.swift
//  PlaytiniTT
//
//  Created by Alexander Ermakov on 23.01.2025.
//

import SpriteKit

struct Constants {
    
    struct General {
        
        static let numberOfSegments: Int = 12
    }
    
    struct Textures {
        static let leftCarTexture = SKTexture(imageNamed: "left_car")
        static let rightCarTexture = SKTexture(imageNamed: "right_car")
        static let roadTexture = SKTexture(imageNamed: "road")
        static let characterTexture = SKTexture(imageNamed: "character")
    }
    
    struct Dimensions {
        
        static let carWidthMultiplier: CGFloat = 0.4
        static let characterScale: CGFloat = 0.75
        static let jumpDistanceMultiplier: CGFloat = 0.1
        static let swipeMinimalLength: CGFloat = 10.0
        static let roadHeightMultiplier: CGFloat = 0.2
        static let grassHeightMultiplier: CGFloat = 0.1
    }
    
    struct Speed {
        
        static let backgroundSpeed: CGFloat = 50.0
    }
    
    struct Timing {
        
        static let jumpDuration: TimeInterval = 0.2
        static let carSpawnWaitingInterval: TimeInterval = 1.5
        static let carSpawnRange: TimeInterval = 0.5
        static let carSpeedRange: ClosedRange<Double> = 1.5...2.5
    }
    
    struct PhysicsCategories {
        
        static let none: UInt32 = 0
        static let character: UInt32 = 0b1
        static let car: UInt32 = 0b10
    }
}
