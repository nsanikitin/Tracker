import UIKit

final class TrackerCreationViewController: UIViewController {
    
    // MARK: - Properties
    
    private let habitButton = UIButton()
    private let irregularEventButton = UIButton()
    var originalViewController: TrackersViewController?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        setupNavigationBar()
        setupViewComponents()
    }
    
    // MARK: - Methods
    
    private func createButton(button: UIButton, title: String, selector: Selector) {
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.backgroundColor = .ypBlack
        button.tintColor = .ypWhite
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
        view.addSubview(button)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
    }
    
    private func switchToNextViewController(isHabit: Bool) {
        let vc = TrackerCreationSetupViewController()
        vc.isHabit = isHabit
        vc.previosViewController = self
        vc.delegate = originalViewController
        
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.modalPresentationStyle = .popover
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
            selector: #selector(habitButtonDidTape)
        )
        
        habitButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            habitButton.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -8),
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            habitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            habitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupIrregularEventButton() {
        createButton(
            button: irregularEventButton,
            title: "Нерегулярное событие",
            selector: #selector(irregularEventButtonDidTape)
        )
        
        irregularEventButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            irregularEventButton.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 8),
            irregularEventButton.heightAnchor.constraint(equalToConstant: 60),
            irregularEventButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            irregularEventButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    // MARK: - Actions
    
    @objc
    private func habitButtonDidTape() {
        switchToNextViewController(isHabit: true)
    }
    
    @objc
    private func irregularEventButtonDidTape() {
        switchToNextViewController(isHabit: false)
    }
}
