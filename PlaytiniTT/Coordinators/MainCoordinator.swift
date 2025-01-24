//
//  MainCoordinator.swift
//  PlaytiniTT
//
//  Created by Alexander Ermakov on 24.01.2025.
//

import UIKit

class MainCoordinator {
    
    // MARK: -
    // MARK: Variables
    
    private let navigationController: UINavigationController
    
    // MARK: -
    // MARK: Initialization
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.start()
    }
    
    // MARK: -
    // MARK: Private functions
    
    private func start() {
        let viewController = GameViewController()
        viewController.eventHandler = { [weak self] event in
            switch event {
            case .showResults:
                self?.showResults()
            }
        }
        
        self.navigationController.pushViewController(viewController, animated: false)
    }
    
    private func showResults() {
        let resultsService = GameSessionManager()
        let presenter = ResultsPresenter(resultsService: resultsService)
        let resultsViewController = ResultsViewController(presenter: presenter)
        presenter.view = resultsViewController
        
        self.navigationController.pushViewController(resultsViewController, animated: true)
    }
}
