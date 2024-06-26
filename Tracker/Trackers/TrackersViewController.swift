import UIKit

final class TrackersViewController: UIViewController {
    
    // MARK: - Properties
    
    private let trackerStore = TrackerStore.shared
    private let trackerCategoryStore = TrackerCategoryStore.shared
    private let trackerRecordStore = TrackerRecordStore.shared
    private let analyticsService = AnalyticsService()
    
    private lazy var filtersButton = UIButton()
    private lazy var datePicker = UIDatePicker()
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
    
    private var categories: [TrackerCategory] = []
    private var completedTrackers: Set<TrackerRecord> = []
    private var completedIrregularEvents: Set<TrackerRecord> = []
    
    var currentCategories = [TrackerCategory]()
    var currentDate: Date = Date()
    var pinnedTrackersCoreData: [TrackerCoreData] = []
    var irregularEvents: [TrackerCategory] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        
        analyticsService.report(event: "open", params: ["screen" : "Main"])
        UserDefaultsStorage().filterType = 0
        
        trackerStore.delegate = self
        categories = getCategories()
        completedTrackers = getCompletedTrackers()
        getCurrentVisibleCategories()
        
        setupNavigationBar()
        setupViewComponents()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        analyticsService.report(event: "close", params: ["screen" : "Main"])
    }
    
    // MARK: - Methods
    
    private func getFilteredCategories() {
        categories = getCategories()
        
        switch UserDefaultsStorage().filterType {
        case 1: // trackers for today
            datePicker.date = Date()
            currentDate = Date()
        case 2: // finished trackers
            getFinishedCategories()
        case 3: // not finished trackers
            getNotFinishedCategories()
        default: // all trackers
            break
        }
        
        getCurrentVisibleCategories()
    }
    
    private func getCurrentVisibleCategories() {
        var newTrackerCategories = categories.map { getTrackerCategoryAtWeekDay(for: $0) }
        newTrackerCategories.removeAll { $0.trackers.isEmpty }
        
        newTrackerCategories.isEmpty ? showStubs() : hideStubs()
        
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
    
    private func getCategories() -> [TrackerCategory] {
        var categories: [TrackerCategory] = []
        
        let pinCategory = getPinnedTrackers()
        if let pinCategory = pinCategory {
            categories.append(pinCategory)
        }
        
        let categoriesCoreData = trackerCategoryStore.trackerCategoriesCoreData
        let otherCategories = categoriesCoreData.compactMap {
            trackerCategoryStore.convertTrackerCategoryCoreDataToTrackerCategory(for: $0)
        }
        
        var otherCategoriesWithoutPinnedTrackers: [TrackerCategory] = []
        for category in otherCategories {
            var unpinnedTrackers: [Tracker] = []
            for tracker in category.trackers {
                if !tracker.isPinned {
                    unpinnedTrackers.append(tracker)
                }
            }
            otherCategoriesWithoutPinnedTrackers.append(TrackerCategory(title: category.title, trackers: unpinnedTrackers))
        }
        
        categories += otherCategoriesWithoutPinnedTrackers
        
        return categories
    }
    
    private func getFinishedCategories() {
        categories = categories.map { category in
            let completedTrackers = category.trackers.filter { tracker in
                isTrackerCompletedOnDate(tracker: tracker)
            }
            return TrackerCategory(title: category.title, trackers: completedTrackers)
        }
    }
    
    private func getNotFinishedCategories() {
        categories = categories.map { category in
            let completedTrackers = category.trackers.filter { tracker in
                !isTrackerCompletedOnDate(tracker: tracker)
            }
            return TrackerCategory(title: category.title, trackers: completedTrackers)
        }
    }
    
    private func isTrackerCompletedOnDate(tracker: Tracker) -> Bool {
        return completedTrackers.contains { completedTracker in
            completedTracker.id == tracker.id && Calendar.current.isDate(completedTracker.date, inSameDayAs: currentDate)
        }
    }
    
    private func getCompletedTrackers() -> Set<TrackerRecord> {
        let trackersRecordCoreData = trackerRecordStore.trackersRecordCoreData
        let trackersRecord = trackersRecordCoreData.compactMap { trackerRecordStore.convertTrackerRecordCoreDataToTrackerRecord(for: $0) }
        completedTrackers = Set(trackersRecord)
        return completedTrackers
    }
    
    private func getPinnedTrackers() -> TrackerCategory? {
        let pinnedTrackersCoreData = trackerStore.trackersCoreData.filter { $0.isPinned }
        
        var pinnedTrackers: [Tracker] = []
        for trackerCoreData in pinnedTrackersCoreData {
            guard let tracker = trackerStore.convertTrackerCoreDataToTracker(for: trackerCoreData) else { return nil }
            pinnedTrackers.append(tracker)
        }
        let pinCategory = TrackerCategory(title: "Закрепленные", trackers: pinnedTrackers)
        
        return pinCategory
    }
    
    private func showStubs() {
        setupTrackImageStub()
        setupTrackLabelStub()
        filtersButton.isHidden = true
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
        setupFiltersButton()
    }
    
    private func setupNavigationBar() {
        let titleText = NSLocalizedString("trackers.title", comment: "Трекеры")
        title = titleText
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addTrackButton = UIBarButtonItem(
            image: UIImage(systemName: "plus")?.applyingSymbolConfiguration(.init(pointSize: 18, weight: .semibold)),
            style: .plain,
            target: self,
            action: #selector(addTrackButtonDidTap)
        )
        addTrackButton.tintColor = .ypBlack
        self.navigationItem.leftBarButtonItem = addTrackButton
        
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
        trackStubImageView.image = UIImage(named: "stub")
        trackStubImageView.isHidden = false
        
        trackStubImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(trackStubImageView)
        
        NSLayoutConstraint.activate([
            trackStubImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            trackStubImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
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
        trackersCollectionView.allowsMultipleSelection = false
        trackersCollectionView.alwaysBounceVertical = true
        
        trackersCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(trackersCollectionView)
        
        NSLayoutConstraint.activate([
            trackersCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            trackersCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            trackersCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            trackersCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupFiltersButton() {
        let buttonText = NSLocalizedString("filters", comment: "Фильтры")
        filtersButton.setTitle(buttonText, for: .normal)
        filtersButton.titleLabel?.font = UIFont.systemFont(ofSize: ViewConfigurationConstants.buttonFontSize)
        filtersButton.backgroundColor = .ypBlue
        filtersButton.tintColor = .ypWhite
        
        filtersButton.isEnabled = true
        filtersButton.addTarget(self, action: #selector(filtersButtonDidTap), for: .touchUpInside)
        
        filtersButton.layer.masksToBounds = true
        filtersButton.layer.cornerRadius = ViewConfigurationConstants.elementsCornerRadius
        
        filtersButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filtersButton)
        
        NSLayoutConstraint.activate([
            filtersButton.widthAnchor.constraint(equalToConstant: 114),
            filtersButton.heightAnchor.constraint(equalToConstant: 50),
            filtersButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            filtersButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    // MARK: - Actions
    
    @objc
    private func addTrackButtonDidTap() {
        let vc = TrackerCreationViewController()
        let navigationController = UINavigationController(rootViewController: vc)
        vc.originalVC = self
        self.present(navigationController, animated: true)
        
        analyticsService.report(event: "click", params: ["screen" : "Main", "item" : "add_track"])
    }
    
    @objc
    private func datePickerValueChanged(_ sender: UIDatePicker) {
        currentDate = sender.date
        
        if currentCategories.isEmpty,
           UserDefaultsStorage().filterType != 0 {
            categories = getCategories()
            filtersButton.isHidden = false
        }
        
        getFilteredCategories()
        
        self.dismiss(animated: false)
        
        analyticsService.report(event: "click", params: ["screen" : "Main", "item" : "filter"])
    }
    
    @objc
    private func filtersButtonDidTap() {
        analyticsService.report(event: "click", params: ["screen" : "Main", "item" : "filter"])
        let vc = FiltersViewController()
        let navigationController = UINavigationController(rootViewController: vc)
        vc.delegate = self
        self.present(navigationController, animated: true)
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
        
        cell.delegate = self
        cell.trackerSelectedDate = currentDate
        
        let currentTracker = currentCategories[indexPath.section].trackers[indexPath.row]
        let isTrackerCompleted = completedTrackers.contains { tracker in
            if tracker.id == currentTracker.id && Calendar.current.isDate(tracker.date, inSameDayAs: currentDate) {
                return true
            } else { return false }
        }
        let completedDays = completedTrackers.filter { $0.id == currentTracker.id }.count
        
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
        return CGSize(
            width: (collectionView.bounds.width - ViewConfigurationConstants.collectionViewDistanceBetweenSectionsForTracker) / ViewConfigurationConstants.collectionViewSectionQuantityForTracker,
            height: ViewConfigurationConstants.collectionViewTrackerSectionHeight)
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

extension TrackersViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackerCellView.identifier,
            for: indexPath
        ) as? TrackerCellView else {
            return UIContextMenuConfiguration()
        }
        
        cell.delegate = self
        
        let contextMenuTracker = currentCategories[indexPath.section].trackers[indexPath.row]
        let contextMenuCategory = currentCategories[indexPath.section]
        let isPinned = contextMenuTracker.isPinned
        let numberOfCompletedDays = completedTrackers.filter{ $0.id == contextMenuTracker.id }.count
        let isIrregularEvent = irregularEvents.contains(
            where: { $0.trackers.contains(
                where: { $0.id == contextMenuTracker.id }
            )}
        )
        
        return cell.configureContextMenu(contextMenuTracker: contextMenuTracker,
                                         contextMenuCategory: contextMenuCategory,
                                         isPinned: isPinned,
                                         isIrregularEvent: isIrregularEvent,
                                         numberOfCompletedDays: numberOfCompletedDays)
    }
}

// MARK: - TrackerCreationSetupViewControllerDelegate Extension

extension TrackersViewController: TrackerCreationSetupViewControllerDelegate {
    
    func updateTrackerCategory(for trackerCategory: TrackerCategory, isHabit: Bool) {
        if !categories.contains(where: { $0.title == trackerCategory.title }) {
            categories.append(trackerCategory)
        } else {
            guard let categoryIndex = categories.firstIndex(where: { $0.title == trackerCategory.title }) else {
                assertionFailure("No Category Index")
                return
            }
            let oldTrackers = categories[categoryIndex].trackers
            let newTrackers = oldTrackers + trackerCategory.trackers
            let newCategory = TrackerCategory(title: trackerCategory.title, trackers: newTrackers)
            categories[categoryIndex] = newCategory
        }
        
        if categories.isEmpty {
            categories.append(trackerCategory)
        }
        
        if !isHabit {
            irregularEvents.append(trackerCategory)
        }
        
        setupCollectionView()
        getCurrentVisibleCategories()
    }
}

// MARK: - TrackerCellViewDelegate Extension

extension TrackersViewController: TrackerCellViewDelegate {
    
    func addCompletedTracker(for trackerID: UUID) {
        let trackerRecord = TrackerRecord(id: trackerID, date: currentDate)
        completedTrackers.insert(trackerRecord)
        trackerRecordStore.addTrackerRecordToCoreData(for: trackerRecord)
        
        if irregularEvents.contains(
            where: { $0.trackers.contains(
                where: { $0.id == trackerID })
            }) {
            completedIrregularEvents.insert(trackerRecord)
            removeTrackerFromCategory(for: trackerID)
            trackerStore.deleteTrackerFromCoreData(for: trackerID)
        }
    }
    
    func removeCompletedTracker(for trackerID: UUID) {
        let trackerRemove = TrackerRecord(id: trackerID, date: currentDate)
        completedTrackers.remove(trackerRemove)
        trackerRecordStore.deleteTrackerRecordFromCoreData(for: trackerRemove)
    }
    
    func deleteTrackerFromCoreData(for trackerID: UUID) {
        let alert = UIAlertController(title: "", message: "Уверены, что хотите удалить трекер?", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            self?.removeTrackerFromCategory(for: trackerID)
            self?.trackerStore.deleteTrackerFromCoreData(for: trackerID)
        })
        
        alert.addAction(UIAlertAction(title: "Отменить", style: .cancel) { _ in })
        present(alert, animated: true)
    }
    
    func showEditViewController(with navigationController: UINavigationController) {
        present(navigationController, animated: true)
    }
    
    func pinOrUnpinTracker(for trackerID: UUID, isPinned: Bool) {
        if isPinned {
            trackerStore.trackersCoreData.first(where: { $0.id == trackerID })?.isPinned = true
            removeTrackerFromCategory(for: trackerID)
        } else {
            trackerStore.trackersCoreData.first(where: { $0.id == trackerID })?.isPinned = false
        }
        
        categories = getCategories()
        getCurrentVisibleCategories()
    }
}

// MARK: - TrackerStoreDelegate Extension

extension TrackersViewController: TrackerStoreDelegate {
    
    func updateTrackers() {
        categories = getCategories()
        getCurrentVisibleCategories()
    }
}

// MARK: - FiltersViewControllerDelegate Extension

extension TrackersViewController: FiltersViewControllerDelegate {
    
    func didSelectFilter() {
        getFilteredCategories()
    }
}
