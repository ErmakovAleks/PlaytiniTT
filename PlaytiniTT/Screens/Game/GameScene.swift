//
//  GameScene.swift
//  PlaytiniTT
//
//  Created by Alexander Ermakov on 21.01.2025.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // MARK: -
    // MARK: Variables
    
    private lazy var backgroundManager: BackgroundManager = {
        BackgroundManager(
            numberOfAvailableSegments: Constants.General.numberOfSegments,
            roadTexture: Constants.Textures.roadTexture,
            scene: self
        )
    }()
    
    private lazy var characterManager: CharacterManager = {
        CharacterManager(
            backgroundManager: self.backgroundManager,
            scene: self,
            characterTexture: Constants.Textures.characterTexture,
            grassHeight: self.grassHeight
        )
    }()
    
    private lazy var carFactory: CarFactoryProtocol = {
        CarFactory(
            roadHeight: self.roadHeight,
            backgroundManager: self.backgroundManager,
            scene: self
        )
    }()
    
    private var roadHeight: CGFloat = 0
    private var grassHeight: CGFloat = 0
    private var jumpHeight: CGFloat = 0
    private var isBackgroundMoving: Bool = true
    private var gameOverView: UIView?
    private var isSwipe: Bool = false
    private var isJumping: Bool = false
    
    // MARK: -
    // MARK: Overrided
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = .zero
        
        self.roadHeight = self.size.height * Constants.Dimensions.roadHeightMultiplier
        self.grassHeight = self.size.height * Constants.Dimensions.grassHeightMultiplier
        self.jumpHeight = self.size.height * Constants.Dimensions.jumpDistanceMultiplier
                
        self.backgroundManager.createBackground()
        self.characterManager.createCharacter()
        self.spawnCarsPeriodically()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.isSwipe = false
        if let _ = touches.first {
            self.characterManager.jump(by: self.jumpHeight)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, !self.isJumping {
            let start = touch.previousLocation(in: self)
            let end = touch.location(in: self)
            
            if end.y < start.y && abs(start.y - end.y) > Constants.Dimensions.swipeMinimalLength {
                self.isSwipe = true
                self.characterManager.jump(by: -jumpHeight)
                self.startJumpCooldown()
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isSwipe { return }
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard self.isBackgroundMoving else { return }
        guard (self.characterManager.character?.frame.minY ?? 0.0) > 0.0 else {
            self.gameOver()
            return
        }
        
        self.backgroundManager.moveBackground(currentTime: currentTime)
    }
    
    // MARK: -
    // MARK: Physics Contact Delegate
    
    func didBegin(_ contact: SKPhysicsContact) {
            let bodyA = contact.bodyA
            let bodyB = contact.bodyB

        if (bodyA.categoryBitMask == Constants.PhysicsCategories.character &&
            bodyB.categoryBitMask == Constants.PhysicsCategories.car) ||
            (bodyA.categoryBitMask == Constants.PhysicsCategories.car &&
             bodyB.categoryBitMask == Constants.PhysicsCategories.character)
        {
            self.handleCollisionBetweenCharacterAndCar()
        }
    }
    
    // MARK: -
    // MARK: Private functions
    
    private func spawnCarsPeriodically() {
        let waitAction = SKAction.wait(
            forDuration: Constants.Timing.carSpawnWaitingInterval,
            withRange: Constants.Timing.carSpawnRange
        )
        
        let spawnAction = SKAction.run { [weak self] in
            guard let configuration = CarConfiguration.random(),
                  let randomRoad = self?.backgroundManager.randomRoad()
            else { return }
            self?.spawnCar(with: configuration, on: randomRoad)
        }
        
        self.run(SKAction.repeatForever(SKAction.sequence([spawnAction, waitAction])))
    }
    
    private func spawnCar(
        with configuration: CarConfiguration,
        on road: SKSpriteNode
    ) {
        let car = self.carFactory.createCar(
            with: configuration,
            on: road,
            sceneWidth: self.size.width
        )
        
        self.addChild(car)
        
        let duration = Double.random(in: Constants.Timing.carSpeedRange)
        let moveAction = configuration.movementAction(
            self.size.width,
            car.size.width,
            duration
        )
        
        car.run(moveAction) { [weak self] in
            self?.backgroundManager.segmentNodes[road.hash]?.remove(car)
        }
    }
    
    private func handleCollisionBetweenCharacterAndCar() {
        guard !self.characterManager.isColliding else { return }
        self.gameOver()
    }
    
    private func showGameOverScreen() {
        guard let view = self.view else { return }
        
        self.gameOverView = UIView(frame: view.bounds)
        guard let gameOverView = self.gameOverView else { return }
        
        gameOverView.backgroundColor = UIColor.red.withAlphaComponent(0.7)

        let gameOverLabel = UILabel()
        gameOverLabel.text = "Game Over!"
        gameOverLabel.textColor = .white
        gameOverLabel.font = UIFont.boldSystemFont(ofSize: 40)
        gameOverLabel.textAlignment = .center
        gameOverLabel.translatesAutoresizingMaskIntoConstraints = false

        gameOverView.addSubview(gameOverLabel)

        NSLayoutConstraint.activate([
            gameOverLabel.centerXAnchor.constraint(equalTo: gameOverView.centerXAnchor),
            gameOverLabel.centerYAnchor.constraint(equalTo: gameOverView.centerYAnchor)
        ])
        
        view.addSubview(gameOverView)
    }
    
    private func gameOver() {
        self.characterManager.isColliding = true
        self.isBackgroundMoving = false
        self.showGameOverScreen()
    }
    
    private func startJumpCooldown() {
        self.isJumping = true
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.Timing.jumpDuration) {
            self.isJumping = false
        }
    }
}
