import UIKit

final class TrackersViewController: UIViewController, UICollectionViewDelegate {
    
    // MARK: - Properties
    
    private lazy var trackStubLabel: UILabel = UILabel()
    private lazy var trackStubImageView: UIImageView = UIImageView()
    private lazy var trackersCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        return collectionView
    }()
    
    var currentCategories = [TrackerCategory]()
    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    var currentDate: Date = Date()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        setupNavigationBar()
        setupViewComponents()
        
        // TODO: - Фильтр трекеров по дате из дейтпикера
        // При изменении даты отображаются трекеры привычек, которые должны быть видны в день недели, выбранный в UIDatePicker
        
        // Когда пользователь нажимает на + в ячейке трекера, добавляется соответствующая запись в completedTrackers. Если пользователь убирает пометку о выполненности в ячейке трекера, элемент удаляется из массива. Чтобы не выполнять линейный поиск по массиву, используйте Set, в котором хранятся id выполненных трекеров;
        
        // новые трекеры добавляются в соответствующую категорию в массиве categories. Чтобы их добавить, нужно создать новую категорию с новым списком трекеров, а затем создать новый список категорий и присвоить его в categories. Мы не рекомендуем менять существующий массив, лучше создайте новый — так будет меньше пространства для трудноуловимых ошибок синхронизации данных;
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
        datePicker.locale = Locale(identifier: "ru_RU")
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
        
        setupCollectionView()
    }
    
    // MARK: - Trackers View Configuration
    
    private func setupTrackImageStub() {
        guard let trackStubImage = UIImage(named: "stub") else { return }
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
    
    private func setupCollectionView() {
        self.trackersCollectionView.dataSource = self
        self.trackersCollectionView.delegate = self
        trackersCollectionView.register(UICollectionView.self, forCellWithReuseIdentifier: "cell")
        trackersCollectionView.register(TrackerCellView.self, forCellWithReuseIdentifier: "cell")
        trackersCollectionView.register(HeaderViewController.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        
        trackersCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(trackersCollectionView)
        
        NSLayoutConstraint.activate([
            trackersCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            trackersCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            trackersCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trackersCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16)
        ])
    }
    
    // MARK: - Actions
    
    @objc
    private func addTrackButtonDidTape() {
        let vc = TrackerCreationViewController()
        // vc.originalViewController = self
        let navigationController = UINavigationController(rootViewController: vc)
        self.present(navigationController, animated: true)
    }
    
    @objc 
    private func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let formattedDate = dateFormatter.string(from: selectedDate)
        print("Выбранная дата: \(formattedDate)")
    }
}

// MARK: - Extensions

extension TrackersViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = UICollectionViewCell()
        return cell
    }
}
