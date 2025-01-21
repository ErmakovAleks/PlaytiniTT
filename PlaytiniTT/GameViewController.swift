//
//  GameViewController.swift
//  PlaytiniTT
//
//  Created by Alexander Ermakov on 21.01.2025.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemPurple
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
