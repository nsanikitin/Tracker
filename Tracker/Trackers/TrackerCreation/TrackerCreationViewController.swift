import UIKit

final class TrackerCreationViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var habitButton = UIButton()
    private lazy var irregularEventButton = UIButton()
    
    weak var originalVC: TrackersViewController?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        setupNavigationBar()
        setupViewComponents()
    }
    
    // MARK: - Methods
    
    private func createButton(button: UIButton, title: String, selector: Selector) {
        button.backgroundColor = .ypBlack
        button.tintColor = .ypWhite
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: ViewConfigurationConstants.buttonFontSize)
        
        button.isEnabled = true
        button.addTarget(self, action: selector, for: .touchUpInside)
        
        button.layer.masksToBounds = true
        button.layer.cornerRadius = ViewConfigurationConstants.elementsCornerRadius
        
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
    }
    
    private func switchToTrackerCreationSetupViewController(isHabit: Bool) {
        let vc = TrackerCreationSetupViewController()
        vc.isHabit = isHabit
        vc.previousVC = self
        vc.delegate = originalVC
        let navigationController = UINavigationController(rootViewController: vc)
        self.present(navigationController, animated: true)
    }
    
    // MARK: - Tracker Creation View Configuration

    private func setupNavigationBar() {
        title = "Создание трекера"
    }
    
    private func setupViewComponents() {
        setupHabitButton()
        setupIrregularEventButton()
    }
    
    private func setupHabitButton() {
        createButton(
            button: habitButton,
            title: "Привычка",
            selector: #selector(habitButtonDidTap)
        )
        
        habitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(habitButton)
        
        NSLayoutConstraint.activate([
            habitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            habitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            habitButton.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -8),
            habitButton.heightAnchor.constraint(equalToConstant: ViewConfigurationConstants.buttonHeight)
        ])
    }
    
    private func setupIrregularEventButton() {
        createButton(
            button: irregularEventButton,
            title: "Нерегулярное событие",
            selector: #selector(irregularEventButtonDidTap)
        )
        
        NSLayoutConstraint.activate([
            irregularEventButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            irregularEventButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            irregularEventButton.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 8),
            irregularEventButton.heightAnchor.constraint(equalToConstant: ViewConfigurationConstants.buttonHeight)
        ])
    }
    
    // MARK: - Actions
    
    @objc
    private func habitButtonDidTap() {
        switchToTrackerCreationSetupViewController(isHabit: true)
    }
    
    @objc
    private func irregularEventButtonDidTap() {
        switchToTrackerCreationSetupViewController(isHabit: false)
    }
}
