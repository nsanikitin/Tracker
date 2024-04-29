import UIKit

final class TrackersViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var trackStubLabel: UILabel = UILabel()
    private lazy var trackStubImageView: UIImageView = UIImageView()
    private var currentDate: Date = Date()
    var currentCategories = [TrackerCategory]()
    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []

    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        setupNavigationBar()
        setupViewComponents()
    }
    
    // MARK: - Methods
    
    private func setupNavigationBar() {
        title = "Трекеры"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Nav Button
        let addTrackButton = UIBarButtonItem(
            image: UIImage(named: "plusButton"),
            style: .plain,
            target: self,
            action: #selector(addTrackButtonDidTape)
        )
        addTrackButton.tintColor = .ypBlack
        self.navigationItem.leftBarButtonItem = addTrackButton
        
        // Nav DatePicker
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        
        // Nav Search Field
        let searchField = UISearchController(searchResultsController: nil)
        searchField.automaticallyShowsCancelButton = true
        self.navigationItem.searchController = searchField
    }
    
    private func setupViewComponents() {
        guard !currentCategories.isEmpty  else {
            setupTrackImageStub()
            setupTrackLabelStub()
            return
        }
        
        // TODO: - Add setup trackers views
    }
    
    private func setupTrackImageStub() {
        guard let trackStubImage = UIImage(named: "trackStub") else { return }
        trackStubImageView = UIImageView(image: trackStubImage)
        
        trackStubImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(trackStubImageView)
        
        NSLayoutConstraint.activate([
            trackStubImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            trackStubImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupTrackLabelStub() {
        trackStubLabel.text = "Что будем отслеживать?"
        trackStubLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        trackStubLabel.textColor = .ypBlack
        
        trackStubLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(trackStubLabel)
        
        NSLayoutConstraint.activate([
            trackStubLabel.topAnchor.constraint(equalTo: trackStubImageView.bottomAnchor, constant: 8),
            trackStubLabel.centerXAnchor.constraint(equalTo: trackStubImageView.centerXAnchor)
        ])
    }
    
    // MARK: - Actions
    
    @objc
    private func addTrackButtonDidTape() {
        let vc = TrackerCreationViewController()
        vc.originalViewController = self
        let navigationController = UINavigationController(rootViewController: vc)
        self.present(navigationController, animated: true)
    }
    
    @objc 
    private func datePickerValueChanged(_ sender: UIDatePicker) {
        // TODO: - Add action with date picker
    }
}

// MARK: - Extensions

extension TrackersViewController: TrackerCreationSetupViewControllerDelegate {
    
    func updateCategories(trackerCategory: TrackerCategory) {
        // TODO: - Add updating of categories
    }
}

