//
//  CharacterManager.swift
//  PlaytiniTT
//
//  Created by Alexander Ermakov on 23.01.2025.
//

import SpriteKit

class CharacterManager {
    
    // MARK: -
    // MARK: Variables
    
    var character: SKSpriteNode?
    var isColliding: Bool = false
    private weak var scene: SKScene?
    private var currentSegmentHash: Int?
    private weak var backgroundManager: BackgroundManager?
    
    private let characterTexture: SKTexture
    private let grassHeight: CGFloat
    
    // MARK: -
    // MARK: Initialization
    
    init(
        backgroundManager: BackgroundManager?,
        scene: SKScene?,
        characterTexture: SKTexture,
        grassHeight: CGFloat
    ) {
        self.backgroundManager = backgroundManager
        self.scene = scene
        self.characterTexture = characterTexture
        self.grassHeight = grassHeight
    }
    
    // MARK: -
    // MARK: Functions
    
    func createCharacter() {
        let aspectRatio = self.characterTexture.size().width / self.characterTexture.size().height
        self.character = SKSpriteNode(texture: self.characterTexture)
        
        guard let character = self.character else { return }
        
        character.size = CGSize(
            width: self.grassHeight * aspectRatio * Constants.Dimensions.characterScale,
            height: self.grassHeight * Constants.Dimensions.characterScale
        )
        
        character.zPosition = 2
        
        character.physicsBody = SKPhysicsBody(rectangleOf: character.size)
        character.physicsBody?.isDynamic = true
        character.physicsBody?.categoryBitMask = Constants.PhysicsCategories.character
        character.physicsBody?.contactTestBitMask = Constants.PhysicsCategories.car
        character.physicsBody?.collisionBitMask = Constants.PhysicsCategories.car
        character.physicsBody?.allowsRotation = false
        
        if let firstGrass = self.backgroundManager?.rows.first(where: { $0.texture != self.backgroundManager?.roadTexture }) {
            character.position = CGPoint(
                x: firstGrass.size.width / 2,
                y: firstGrass.position.y
            )
            
            self.backgroundManager?.segmentNodes[firstGrass.hash]?.insert(character)
            self.currentSegmentHash = firstGrass.hash
        }
        
        self.scene?.addChild(character)
    }
    
    func jump(by height: CGFloat) {
        guard let scene = self.scene else { return }
        
        if
            (height > 0 && !canJumpForward(scene: scene))
            || (height < 0 && !canJumpBackward(scene: scene))
        {
            return
        }
        
        let jumpAction = SKAction.sequence([
            SKAction.moveBy(x: 0, y: height, duration: Constants.Timing.jumpDuration),
            SKAction.run { [weak self] in
                self?.changeCurrentSegment()
            }
        ])
        
        self.character?.run(jumpAction)
    }
    
    private func changeCurrentSegment() {
        guard let character = self.character else { return }
        
        self.backgroundManager?.segmentNodes[self.currentSegmentHash ?? 0]?.remove(character)
        if let currentRow = self.backgroundManager?.rows
            .first(where: { $0.frame.contains(character.position) }) {
            self.backgroundManager?.segmentNodes[currentRow.hash]?.insert(character)
            self.currentSegmentHash = currentRow.hash
        }
    }
    
    private func canJumpForward(scene: SKScene) -> Bool {
        guard let character = self.character else { return false }
        
        return backgroundManager?.rows.contains(where: {
            $0.position.y > character.position.y &&
            $0.texture == nil &&
            $0.frame.maxY <= scene.size.height
        }) ?? false
    }

    private func canJumpBackward(scene: SKScene) -> Bool {
        guard let character = self.character else { return false }
        
        return backgroundManager?.rows.contains(where: {
            $0.position.y < character.position.y &&
            $0.texture == nil &&
            $0.frame.minY >= 0
        }) ?? false
    }
}
