import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    private func switchToTabBar() {
        window?.rootViewController = TabBarController()
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        if UserDefaultsStorage().onboardingIsCompleted ?? false {
            switchToTabBar()
        } else {
            let onboardingVC = OnboardingViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
            window?.rootViewController = onboardingVC
            onboardingVC.onboardingIsFinished = switchToTabBar
        }
        
        window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {}
    
    func sceneDidBecomeActive(_ scene: UIScene) {}
    
    func sceneWillResignActive(_ scene: UIScene) {}
    
    func sceneWillEnterForeground(_ scene: UIScene) {}
    
    func sceneDidEnterBackground(_ scene: UIScene) {}
}
