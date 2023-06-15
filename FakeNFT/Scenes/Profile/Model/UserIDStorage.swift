//
//  UserIDStorage.swift
//  FakeNFT
//

import Foundation

final class UserIDStorage: UserIDStorageProtocol {

    private let userDefaults = UserDefaults.standard

    private enum Keys: String {
        case userID
    }

    private(set) var userID: String {
        get {
            guard let userID = userDefaults.string(forKey: Keys.userID.rawValue) else {
                print("Unable to get userID value from local storage")
                return .init()
            }
            return userID
        }
        set {
            userDefaults.set(newValue, forKey: Keys.userID.rawValue)
        }
    }

    init() {
        self.set(userID: Constants.fakeUserIDString)
    }

    func set(userID: String) {
        self.userID = userID
    }
}
