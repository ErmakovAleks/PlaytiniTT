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
    
    var eventHandler: ((GameViewControllerEvent) -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = SKView(frame: self.view.frame)
        self.view = skView
        let scene = GameScene(size: CGSize(width: skView.bounds.width, height: skView.bounds.height))
        scene.scaleMode = .aspectFill
        
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        
        skView.presentScene(scene) // вынести в отдельный метод
        // добавить фабрику (возможно)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
