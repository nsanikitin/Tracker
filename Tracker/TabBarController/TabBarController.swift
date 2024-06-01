import UIKit

final class TabBarController: UITabBarController {
    
    // MARK: - Properties
    
    private let trackersViewController = TrackersViewController()
    private let statisticViewController = StatisticViewController()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBarAppearance()
        setupTabBarItems()
    }
    
    private func setupTabBarAppearance() {
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.backgroundColor = .ypWhite
            tabBar.scrollEdgeAppearance = appearance
        }
    }
    
    private func setupTabBarItems() {
        trackersViewController.tabBarItem.title = "Трекеры"
        trackersViewController.tabBarItem.image = UIImage(named: "trackerTab")
        
        statisticViewController.tabBarItem.title = "Статистика"
        statisticViewController.tabBarItem.image = UIImage(named: "statisticTab")
        
        viewControllers = [
            UINavigationController(rootViewController: trackersViewController),
            UINavigationController(rootViewController: statisticViewController)
        ]
    }
}
