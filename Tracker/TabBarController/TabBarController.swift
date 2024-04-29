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
        // Track Tab
        trackersViewController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(named: "trackerTab"),
            selectedImage: nil
        )
        
        // Statistic Tab
        statisticViewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: "statisticTab"),
            selectedImage: nil
        )
        
        // Tab Items
        viewControllers = [trackersViewController, statisticViewController]
    }
}
