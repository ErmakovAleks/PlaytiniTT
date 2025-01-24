//
//  GameSessionManager.swift
//  PlaytiniTT
//
//  Created by Alexander Ermakov on 24.01.2025.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    
    private let key: String
    private let defaultValue: T
    private let userDefaults: UserDefaults

    init(
        key: String,
        defaultValue: T,
        userDefaults: UserDefaults = .standard
    ) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }

    var wrappedValue: T {
        get {
            return userDefaults.object(forKey: key) as? T ?? defaultValue
        }
        set {
            userDefaults.set(newValue, forKey: key)
        }
    }
}

class GameSessionManager: ResultsServiceProtocol {
    
    // MARK: -
    // MARK: Variables
    
    @UserDefault(key: "gameSessions", defaultValue: [])
    private var savedSessions: [Data]

    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    // MARK: -
    // MARK: Functions

    func saveSession(startDate: Date, duration: TimeInterval) {
        let session = GameSession(startDate: startDate, duration: duration)
        if let encoded = try? self.encoder.encode(session) {
            self.savedSessions.append(encoded)
        }
    }

    func clearSessions() {
        self.savedSessions = []
    }
    
    // MARK: -
    // MARK: Result Service Protocol
    
    func loadSessions() -> [GameSession] {
        return self.savedSessions.compactMap { try? self.decoder.decode(GameSession.self, from: $0) }
    }
}
