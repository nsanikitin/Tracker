import UIKit

protocol TrackerCreationSetupViewControllerDelegate: AnyObject {
    func updateCategories(trackerCategory: TrackerCategory)
}

final class TrackerCreationSetupViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: TrackerCreationSetupViewControllerDelegate?
    var isHabit: Bool = false
    var previosViewController: TrackerCreationViewController?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        setupNavigationBar()
        setupViewComponents()
    }
    
    // MARK: - Methods
    
    private func setupNavigationBar() {
        title = isHabit ? "Новая привычка" : "Новое нерегулярное событие"
    }
    
    private func setupViewComponents() {
        
    }

}
