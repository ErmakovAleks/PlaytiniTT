//
//  ResultsViewController.swift
//  PlaytiniTT
//
//  Created by Alexander Ermakov on 24.01.2025.
//

import UIKit

import UIKit

class ResultsViewController: UIViewController {
    
    // MARK: -
    // MARK: Variables
    
    private var dataSource: UITableViewDiffableDataSource<Int, GameSession>?
    
    private let presenter: ResultsPresenterProtocol
    private let tableView = UITableView()
    
    // MARK: -
    // MARK: Initialization

    init(presenter: ResultsPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    // MARK: Overrided

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Game results"
        
        self.setupUI()
        self.setupDataSource()
        self.presenter.loadResults()
    }

    // MARK: -
    // MARK: Functions
    
    func reloadTableData() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, GameSession>()
        snapshot.appendSections([0])
        snapshot.appendItems(self.presenter.results, toSection: 0)
        self.dataSource?.apply(snapshot, animatingDifferences: true)
    }

    private func setupUI() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)

        self.tableView.backgroundColor = Constants.Colors.grass
        self.tableView.register(ResultCell.self, forCellReuseIdentifier: String(describing: ResultCell.self))
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.tableView)

        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }

    private func setupDataSource() {
        self.dataSource = UITableViewDiffableDataSource<Int, GameSession>(tableView: self.tableView) { tableView, indexPath, session in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: ResultCell.self),
                for: indexPath) as? ResultCell else
            {
                return UITableViewCell()
            }
            
            cell.configure(with: session)
            
            return cell
        }
    }
}
