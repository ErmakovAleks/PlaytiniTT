//
//  CarFactory.swift
//  PlaytiniTT
//
//  Created by Alexander Ermakov on 23.01.2025.
//

import SpriteKit

protocol CarFactoryProtocol {
    
    func createCar(
        with configuration: CarConfiguration,
        on road: SKSpriteNode,
        sceneWidth: CGFloat
    ) -> SKSpriteNode
}


enum CarConfiguration: CaseIterable {
    
    case left
    case right

    // MARK: -
    // MARK: Variables
    
    var texture: SKTexture {
        switch self {
        case .left:
            return Constants.Textures.leftCarTexture
        case .right:
            return Constants.Textures.rightCarTexture
        }
    }

    var initialXPosition: (_ sceneWidth: CGFloat, _ carWidth: CGFloat) -> CGFloat {
        switch self {
        case .left:
            return { sceneWidth, carWidth in sceneWidth + carWidth / 2 }
        case .right:
            return { sceneWidth, carWidth in -carWidth / 2 }
        }
    }

    var movementAction: (_ sceneWidth: CGFloat, _ carWidth: CGFloat, _ duration: TimeInterval) -> SKAction {
        switch self {
        case .left:
            return { sceneWidth, carWidth, duration in
                SKAction.sequence([
                    SKAction.moveTo(x: -carWidth / 2, duration: duration),
                    SKAction.removeFromParent()
                ])
            }
        case .right:
            return { sceneWidth, carWidth, duration in
                SKAction.sequence([
                    SKAction.moveTo(x: sceneWidth + carWidth / 2, duration: duration),
                    SKAction.removeFromParent()
                ])
            }
        }
    }
    
    // MARK: -
    // MARK: Functions
    
    static func random() -> CarConfiguration? {
        return self.allCases.randomElement()
    }
}

class CarFactory: CarFactoryProtocol {
    
    // MARK: -
    // MARK: Variables
    
    private weak var backgroundManager: BackgroundManager?
    private weak var scene: SKScene?
    private let roadHeight: CGFloat
    
    // MARK: -
    // MARK: Initialization
    
    init(roadHeight: CGFloat, backgroundManager: BackgroundManager?, scene: SKScene?) {
        self.roadHeight = roadHeight
        self.backgroundManager = backgroundManager
        self.scene = scene
    }
    
    // MARK: -
    // MARK: Functions
    
    func createCar(
        with configuration: CarConfiguration,
        on road: SKSpriteNode,
        sceneWidth: CGFloat
    ) -> SKSpriteNode {
        let car = SKSpriteNode(texture: configuration.texture)
        let aspectRatio = configuration.texture.size().width / configuration.texture.size().height
        car.size = CGSize(
            width: self.roadHeight * Constants.Dimensions.carWidthMultiplier * aspectRatio,
            height: self.roadHeight * Constants.Dimensions.carWidthMultiplier
        )
        
        car.zPosition = 1
        car.position = CGPoint(
            x: configuration.initialXPosition(sceneWidth, car.size.width),
            y: configuration == .left
                ? road.position.y + road.size.height / 4
                : road.position.y - road.size.height / 4
        )
        
        car.physicsBody = SKPhysicsBody(rectangleOf: car.size)
        car.physicsBody?.isDynamic = false
        car.physicsBody?.categoryBitMask = Constants.PhysicsCategories.car
        car.physicsBody?.contactTestBitMask = Constants.PhysicsCategories.character
        car.physicsBody?.collisionBitMask = Constants.PhysicsCategories.character
        
        self.backgroundManager?.segmentNodes[road.hash]?.insert(car)
        
        return car
    }
}
