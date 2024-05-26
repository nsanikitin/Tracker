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
}
