//
//  GameOverView.swift
//  PlaytiniTT
//
//  Created by Alexander Ermakov on 24.01.2025.
//

import UIKit

extension Constants {
    
    struct GameOverViewConstraints {
        
        static let buttonBottom: CGFloat = 80.0
        static let buttonSide: CGFloat = 20.0
        static let buttonHeight: CGFloat = 50.0
        static let titleCenterY: CGFloat = 50.0
    }
}

class GameOverView: UIView {
    
    // MARK: -
    // MARK: Variables
    
    private var onShowResults: (() -> Void)?
    private var onPlayAgain: (() -> Void)?
    
    let titleLabel = UILabel()
    private let showResultsButton = UIButton(type: .system)
    private let playAgainButton = UIButton(type: .system)

    // MARK: -
    // MARK: Initialization
    
    init(
        frame: CGRect,
        onShowResults: @escaping () -> Void,
        onPlayAgain: @escaping () -> Void
    ) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.red.withAlphaComponent(0.7)

        self.setupUI()

        self.onShowResults = onShowResults
        self.onPlayAgain = onPlayAgain
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: -
    // MARK: Private functions
    
    private func setupUI() {
        self.configureTitleLabel()
        self.configureShowResultsButton()
        self.configurePlayAgainButton()
        self.setupConstraints()
    }
    
    private func configureTitleLabel() {
        self.titleLabel.text = "Game over!"
        self.titleLabel.textColor = .white
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 40)
        self.titleLabel.textAlignment = .center
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.isHidden = true
        
        self.addSubview(self.titleLabel)
    }
    
    private func configureShowResultsButton() {
        self.configureButton(
            self.showResultsButton,
            title: "Results",
            color: .orange,
            action: #selector(self.handleShowResults)
        )
        
        self.addSubview(self.showResultsButton)
    }
    
    private func configurePlayAgainButton() {
        self.configureButton(
            self.playAgainButton,
            title: "Game",
            color: .systemGreen,
            action: #selector(self.handlePlayAgain)
        )
        
        self.addSubview(self.playAgainButton)
    }
    
    private func configureButton(
        _ button: UIButton,
        title: String,
        color: UIColor,
        action: Selector
    ) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = Constants.Fonts.buttonTitleFont
        button.backgroundColor = color
        button.layer.cornerRadius = Constants.Dimensions.buttonCornerRadius
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: action, for: .touchUpInside)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            self.titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -Constants.GameOverViewConstraints.titleCenterY)
        ])
        
        
        NSLayoutConstraint.activate([
            self.showResultsButton.trailingAnchor.constraint(equalTo: self.centerXAnchor, constant: -Constants.GameOverViewConstraints.buttonSide),
            self.showResultsButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Constants.GameOverViewConstraints.buttonBottom),
            self.showResultsButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.GameOverViewConstraints.buttonSide),
            self.showResultsButton.heightAnchor.constraint(equalToConstant: Constants.GameOverViewConstraints.buttonHeight),
            
            self.playAgainButton.leadingAnchor.constraint(equalTo: self.centerXAnchor, constant: Constants.GameOverViewConstraints.buttonSide),
            self.playAgainButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Constants.GameOverViewConstraints.buttonBottom),
            self.playAgainButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.GameOverViewConstraints.buttonSide),
            self.playAgainButton.heightAnchor.constraint(equalToConstant: Constants.GameOverViewConstraints.buttonHeight)
        ])
    }

    @objc private func handleShowResults() {
        self.onShowResults?()
    }

    @objc private func handlePlayAgain() {
        self.onPlayAgain?()
    }
}
