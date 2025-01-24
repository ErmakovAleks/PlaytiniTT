//
//  ResultCell.swift
//  PlaytiniTT
//
//  Created by Alexander Ermakov on 24.01.2025.
//

import UIKit

extension Constants {
    
    struct ResultCellConstraints {
        
        static let containerRadius: CGFloat = 10.0
        static let containerHeight: CGFloat = 32.0
        static let containerVertical: CGFloat = 4.0
        static let containerHorizontal: CGFloat = 8.0
        static let labelHorizontal: CGFloat = 16.0
        static let labelBetween: CGFloat = 8.0
    }
}

class ResultCell: UITableViewCell {
    
    // MARK: -
    // MARK: Variables
    
    private let containerView = UIView()
    private let dateLabel = UILabel()
    private let durationLabel = UILabel()
    
    // MARK: -
    // MARK: Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    // MARK: Functions
    
    func configure(with result: GameSession) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy hh:mm:ss"
        self.dateLabel.text = dateFormatter.string(from: result.startDate)
        
        let hours = Int(result.duration) / 3600
        let minutes = (Int(result.duration) % 3600) / 60
        let seconds = Int(result.duration) % 60
        self.durationLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    private func setupUI() {
        self.contentView.backgroundColor = Constants.Colors.grass
        
        self.containerView.layer.cornerRadius = Constants.ResultCellConstraints.containerRadius
        self.containerView.backgroundColor = UIColor.white
        self.containerView.layer.masksToBounds = true
        
        self.contentView.addSubview(self.containerView)
        
        self.dateLabel.font = Constants.Fonts.labelFont
        self.dateLabel.textAlignment = .left
        
        self.durationLabel.font = Constants.Fonts.labelFont
        self.durationLabel.textAlignment = .right
        self.durationLabel.textColor = .gray
        
        self.containerView.addSubview(self.dateLabel)
        self.containerView.addSubview(self.durationLabel)
        
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        self.dateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.durationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.containerView.heightAnchor.constraint(equalToConstant: Constants.ResultCellConstraints.containerHeight),
            self.containerView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: Constants.ResultCellConstraints.containerVertical),
            self.containerView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -Constants.ResultCellConstraints.containerVertical),
            self.containerView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: Constants.ResultCellConstraints.containerHorizontal),
            self.containerView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -Constants.ResultCellConstraints.containerHorizontal),
            
            self.dateLabel.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: Constants.ResultCellConstraints.labelHorizontal),
            self.dateLabel.centerYAnchor.constraint(equalTo: self.containerView.centerYAnchor),
            
            self.durationLabel.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -Constants.ResultCellConstraints.labelHorizontal),
            self.durationLabel.centerYAnchor.constraint(equalTo: self.containerView.centerYAnchor),
            
            self.dateLabel.trailingAnchor.constraint(lessThanOrEqualTo: durationLabel.leadingAnchor, constant: -Constants.ResultCellConstraints.labelBetween)
        ])
    }
}
