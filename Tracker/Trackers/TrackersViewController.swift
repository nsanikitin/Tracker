import UIKit

final class TrackersViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var trackStubLabel: UILabel = UILabel()
    private lazy var trackStubImageView: UIImageView = UIImageView()
    private lazy var trackersCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.register(
            TrackerCellView.self,
            forCellWithReuseIdentifier: TrackerCellView.identifier
        )
        collectionView.register(
            TrackerHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TrackerHeaderView.identifier
        )
        return collectionView
    }()
    
    private var currentCategories = [TrackerCategory]()
    private var categories: [TrackerCategory] = []
    private var completedTrackers: Set<TrackerRecord> = []
    
    var currentDate: Date = Date()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        
        categories = CategoriesMock.shared.categories // categories mocks to check a trackers filter
        getCurrentVisibleCategories()
        
        setupNavigationBar()
        setupViewComponents()
    }
    
    // MARK: - Methods
    
    private func getCurrentVisibleCategories() {
        var newTrackerCategories = categories.map { getTrackerCategoryAtWeekDay(for: $0) }
        newTrackerCategories.removeAll { $0.trackers.isEmpty }
        
        if newTrackerCategories.isEmpty {
            showStubs()
        } else {
            hideStubs()
        }
        
        currentCategories = newTrackerCategories
        trackersCollectionView.reloadData()
    }
    
    private func getTrackerCategoryAtWeekDay(for category: TrackerCategory) -> TrackerCategory {
        let calendar = Calendar.current
        let weekDay = calendar.component(.weekday, from: currentDate)
        let newTrackers = category.trackers.filter { $0.schedule.contains { $0.rawValue == weekDay } }
        let newTrackerCategory = TrackerCategory(title: category.title, trackers: newTrackers)
        
        return newTrackerCategory
    }
    
    private func removeTrackerFromCategory(for trackerID: UUID) {
        var newCategories: [TrackerCategory] = []
        for category in categories {
            var newTrackers: [Tracker] = []
            for tracker in category.trackers {
                if trackerID != tracker.id {
                    newTrackers.append(tracker)
                }
            }
            newCategories.append(TrackerCategory(title: category.title, trackers: newTrackers))
        }
        categories = newCategories
    }
    
    private func showStubs() {
        setupTrackImageStub()
        setupTrackLabelStub()
    }
    
    private func hideStubs() {
        trackStubImageView.isHidden = true
        trackStubLabel.isHidden = true
    }
    
    // MARK: - Trackers View Configuration
    
    private func setupViewComponents() {
        if currentCategories.isEmpty {
            showStubs()
            return
        }
        
        setupCollectionView()
    }
    
    private func setupNavigationBar() {
        title = "Трекеры"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addTrackButton = UIBarButtonItem(
            image: UIImage(systemName: "plus")?.applyingSymbolConfiguration(.init(pointSize: 18, weight: .semibold)),
            style: .plain,
            target: self,
            action: #selector(addTrackButtonDidTape)
        )
        addTrackButton.tintColor = .ypBlack
        self.navigationItem.leftBarButtonItem = addTrackButton
        
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        
        let searchField = UISearchController(searchResultsController: nil)
        searchField.searchBar.placeholder = "Поиск"
        searchField.searchBar.setValue("Отменить", forKey: "cancelButtonText")
        searchField.automaticallyShowsCancelButton = true
        self.navigationItem.searchController = searchField
    }
    
    private func setupTrackImageStub() {
        guard let trackStubImage = UIImage(named: "stub") else { return }
        trackStubImageView = UIImageView(image: trackStubImage)
        trackStubImageView.isHidden = false
        
        trackStubImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(trackStubImageView)
        
        NSLayoutConstraint.activate([
            trackStubImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            trackStubImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupTrackLabelStub() {
        trackStubLabel.text = "Что будем отслеживать?"
        trackStubLabel.font = UIFont.systemFont(ofSize: ViewConfigurationConstants.labelFontSize)
        trackStubLabel.textColor = .ypBlack
        trackStubLabel.isHidden = false
        
        trackStubLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(trackStubLabel)
        
        NSLayoutConstraint.activate([
            trackStubLabel.topAnchor.constraint(equalTo: trackStubImageView.bottomAnchor, constant: 8),
            trackStubLabel.centerXAnchor.constraint(equalTo: trackStubImageView.centerXAnchor)
        ])
    }
    
    private func setupCollectionView() {
        trackersCollectionView.dataSource = self
        trackersCollectionView.delegate = self
        
        trackersCollectionView.backgroundColor = .clear
        
        trackersCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(trackersCollectionView)
        
        NSLayoutConstraint.activate([
            trackersCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            trackersCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            trackersCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            trackersCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    // MARK: - Actions
    
    @objc
    private func addTrackButtonDidTape() {
        let vc = TrackerCreationViewController()
        let navigationController = UINavigationController(rootViewController: vc)
        vc.originalVC = self
        self.present(navigationController, animated: true)
    }
    
    @objc
    private func datePickerValueChanged(_ sender: UIDatePicker) {
        currentDate = sender.date
        getCurrentVisibleCategories()
        self.dismiss(animated: false)
    }
}

// MARK: - Collection View Extensions

extension TrackersViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return currentCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackerCellView.identifier,
            for: indexPath
        ) as? TrackerCellView else {
            return UICollectionViewCell()
        }
        
        let currentTracker = currentCategories[indexPath.section].trackers[indexPath.row]
        cell.delegate = self
        cell.trackerCurrentDate = currentDate
        
        let isTrackerCompleted = completedTrackers.contains { tracker in
            if tracker.id == currentTracker.id && Calendar.current.isDate(tracker.date, inSameDayAs: currentDate) {
                return true
            } else { return false }
        }
        let completedDays = completedTrackers.filter{ $0.id == currentTracker.id }.count
        
        cell.isTrackerCompleted = isTrackerCompleted
        cell.completedDaysCounter = completedDays
        cell.setupTrackerCell(for: currentTracker)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: TrackerHeaderView.identifier,
            for: indexPath
        ) as? TrackerHeaderView else {
            return UICollectionReusableView()
        }
        header.titleLabel.text = currentCategories[indexPath.section].title
        
        return header
    }
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width - 9) / 2, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width,
                                                         height: UIView.layoutFittingExpandedSize.height),
                                                  withHorizontalFittingPriority: .required,
                                                  verticalFittingPriority: .fittingSizeLevel)
    }
}

// MARK: - TrackerCreationSetupViewControllerDelegate Extension

extension TrackersViewController: TrackerCreationSetupViewControllerDelegate {
    
    func updateTrackerCategory(for trackerCategory: TrackerCategory) {
        guard !categories.isEmpty else {
            categories.append(trackerCategory)
            return
        }
        
        for category in categories {
            if trackerCategory.title == category.title {
                let newTrackers = category.trackers + trackerCategory.trackers
                categories.append(TrackerCategory(title: category.title, trackers: newTrackers))
                break
            } else {
                categories.append(trackerCategory)
                break
            }
        }
        
        getCurrentVisibleCategories()
    }
}

// MARK: - TrackerCellViewDelegate Extension

extension TrackersViewController: TrackerCellViewDelegate {
    
    func addCompletedTracker(for trackerID: UUID) {
        let trackerRecord = TrackerRecord(id: trackerID, date: currentDate)
        completedTrackers.insert(trackerRecord)
        
        let trackerSetup = TrackerCreationSetupViewController()
        if trackerSetup.isHabit == false {
            removeTrackerFromCategory(for: trackerID)
        }
    }
    
    func removeCompletedTracker(for trackerID: UUID) {
        let trackerRemove = TrackerRecord(id: trackerID, date: currentDate)
        completedTrackers.remove(trackerRemove)
    }
}
