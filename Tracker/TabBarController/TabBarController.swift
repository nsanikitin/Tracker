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
        let trackersTabText = NSLocalizedString("trackers.tab", comment: "Трекеры")
        trackersViewController.tabBarItem.title = trackersTabText
        trackersViewController.tabBarItem.image = UIImage(named: "trackerTab")
        
        let statisticTabText = NSLocalizedString("statistic.tab", comment: "Статистика")
        statisticViewController.tabBarItem.title = statisticTabText
        statisticViewController.tabBarItem.image = UIImage(named: "statisticTab")
        
        viewControllers = [
            UINavigationController(rootViewController: trackersViewController),
            UINavigationController(rootViewController: statisticViewController)
        ]
    }
}
