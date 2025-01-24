//
//  GameViewController.swift
//  PlaytiniTT
//
//  Created by Alexander Ermakov on 21.01.2025.
//

import UIKit
import SpriteKit
import GameplayKit

enum GameViewControllerEvent {
    case showResults
}

class GameViewController: UIViewController {
    
    // MARK: -
    // MARK: Variables
    
    var eventHandler: ((GameViewControllerEvent) -> ())?
    
    // MARK: -
    // MARK: Overrided

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presentScene()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: -
    // MARK: Private functions
    
    private func presentScene() {
        let skView = SKView(frame: self.view.frame)
        self.view = skView
        let scene = GameScene(
            size: CGSize(width: skView.bounds.width, height: skView.bounds.height)
        )
        
        scene.scaleMode = .aspectFill
        scene.resultsHandler = { [weak self] in
            self?.eventHandler?(.showResults)
        }
    
        skView.presentScene(scene)
    }
}
