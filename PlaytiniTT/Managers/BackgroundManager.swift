//
//  BackgroundManager.swift
//  PlaytiniTT
//
//  Created by Alexander Ermakov on 23.01.2025.
//

import SpriteKit

class BackgroundManager {
    
    // MARK: -
    // MARK: Variables
    
    var segmentNodes = [Int: Set<SKSpriteNode>]()
    var rows = [SKSpriteNode]()
    var lastUpdateTime: TimeInterval = 0
    private weak var scene: SKScene?
    
    let roadTexture: SKTexture
    private let numberOfAvailableSegments: Int
    private let grassHeight: CGFloat
    private let roadHeight: CGFloat
    
    // MARK: -
    // MARK: Initialization
    
    init(
        numberOfAvailableSegments: Int,
        roadTexture: SKTexture,
        scene: SKScene
    ) {
        self.numberOfAvailableSegments = numberOfAvailableSegments
        self.roadTexture = roadTexture
        self.scene = scene
        
        self.grassHeight = (self.scene?.size.height ?? 0.0) * 0.1
        self.roadHeight = (self.scene?.size.height ?? 0.0) * 0.2
    }
    
    // MARK: -
    // MARK: Functions
    
    func createBackground() {
        guard let scene = self.scene else { return }
        
        for i in 0..<self.numberOfAvailableSegments {
            let segment: SKSpriteNode
            if i % 2 == 0 {
                segment = SKSpriteNode(texture: self.roadTexture)
                let aspectRatio = self.roadTexture.size().width / self.roadTexture.size().height
                segment.size = CGSize(width: self.roadHeight * aspectRatio, height: self.roadHeight)
                segment.position = CGPoint(
                    x: scene.size.width / 2,
                    y: CGFloat(i / 2) * (self.roadHeight + self.grassHeight) + self.roadHeight / 2
                )
            } else {
                segment = SKSpriteNode(
                    color: Constants.Colors.grass,
                    size: CGSize(width: scene.size.width, height: self.grassHeight)
                )
                
                segment.position = CGPoint(
                    x: scene.size.width / 2,
                    y: CGFloat((i - 1) / 2) * (self.roadHeight + self.grassHeight) + self.roadHeight + self.grassHeight / 2
                )
            }
            
            segment.zPosition = 0
            scene.addChild(segment)
            self.rows.append(segment)
            self.segmentNodes[segment.hash] = Set<SKSpriteNode>()
        }
    }
    
    func moveBackground(currentTime: TimeInterval) {
        let dt = lastUpdateTime > 0 ? currentTime - self.lastUpdateTime : 0
        self.lastUpdateTime = currentTime
        let distance = CGFloat(dt) * Constants.Speed.backgroundSpeed

        for segment in self.rows {
            segment.position.y -= distance
            self.segmentNodes[segment.hash]?.forEach { node in
                node.position.y -= distance
            }

            if segment.position.y < -segment.frame.height / 2 {
                segment.position.y += (self.roadHeight + self.grassHeight) * CGFloat(self.numberOfAvailableSegments / 2)
            }
        }
    }
    
    func randomRoad() -> SKSpriteNode? {
        let roadNodes = rows
            .filter { $0.texture == roadTexture && $0.position.y <= ((self.scene?.size.height ?? 0.0) + $0.size.height / 2) }
        
        return roadNodes.randomElement()
    }
}
