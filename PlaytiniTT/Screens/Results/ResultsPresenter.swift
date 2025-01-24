//
//  ResultsPresenter.swift
//  PlaytiniTT
//
//  Created by Alexander Ermakov on 24.01.2025.
//

protocol ResultsPresenterProtocol {
    
    var results: [GameSession] { get }
    
    func loadResults()
}

protocol ResultsServiceProtocol {
    
    func loadSessions() -> [GameSession]
}

class ResultsPresenter: ResultsPresenterProtocol {
    
    // MARK: -
    // MARK: Variables
    
    weak var view: ResultsViewController?
    private(set) var results = [GameSession]()
    private let resultsService: ResultsServiceProtocol
    
    // MARK: -
    // MARK: Initialization

    init(resultsService: ResultsServiceProtocol, view: ResultsViewController? = nil) {
        self.resultsService = resultsService
        self.view = view
    }
    
    // MARK: -
    // MARK: Results Presenter Protocol

    func loadResults() {
        self.results = resultsService.loadSessions().sorted { $0.duration > $1.duration }
        self.view?.reloadTableData()
    }
}
