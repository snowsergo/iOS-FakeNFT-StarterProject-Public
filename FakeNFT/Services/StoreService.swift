import Foundation

final class StoreService {
    private let userDefaults = UserDefaults.standard
    
    func store<E>(key: StoreKeys, value: E) {
        userDefaults.set(value as Any, forKey: key.rawValue)
    }
    
    func getValue(for key: StoreKeys, type: StoreTypes) -> Any? {
        let key = key.rawValue
        switch type {
        case .integer:
            return userDefaults.integer(forKey: key)
        case .string:
            return userDefaults.string(forKey: key)
        case .bool:
            return userDefaults.bool(forKey: key)
        }
    }
}
