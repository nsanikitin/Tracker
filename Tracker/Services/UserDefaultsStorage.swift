import Foundation

final class UserDefaultsStorage {
    
    private let userDefaults = UserDefaults.standard
    
    var onboardingIsCompleted: Bool? {
        get {
            userDefaults.bool(forKey: "onboardingIsCompleted")
        }
        set {
            userDefaults.set(true, forKey: "onboardingIsCompleted")
        }
    }
    
    var filterType: Int? {
        get {
            userDefaults.integer(forKey: "filterType")
        }
        set {
            userDefaults.setValue(newValue, forKey: "filterType")
        }
    }
}
