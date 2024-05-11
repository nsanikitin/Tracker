import UIKit

final class TrackerCreationSetupViewController: UIViewController {
    
    // MARK: - Properties
    
    private var trackerCategoryAndScheduleTableView = UITableView()
    private var newTrackerName: String?
    private var newTrackerSchedule: [WeekDay] = []
    private var newTrackerEmoji: String?
    private var newTrackerColor: UIColor?
    private var shortSchedule: String = "" {
        didSet {
            trackerCategoryAndScheduleTableView.reloadData()
        }
    }
    
    private let emojiCollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.register(EmojiCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()
    private let colorCollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.register(ColorCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()
    private let createTrackerButton = UIButton()
    private let cancelButton = UIButton()
    private let trackerNameTextField = UITextField()
    
    var isHabit: Bool = false
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        setupNavigationBar()
        setupViewComponents()
    }
    
    // MARK: - Methods
    
    private func activateCreateTrackerButton() {
        createTrackerButton.isEnabled = true
        createTrackerButton.backgroundColor = .ypBlack
    }
    
    private func isTrackerDataReady() {
        guard newTrackerName == nil,
        newTrackerColor == nil,
        newTrackerEmoji == nil else {
            return
        }
        guard !isHabit, newTrackerSchedule.isEmpty else {
            return
        }
        activateCreateTrackerButton()
    }
    
    // MARK: - Tracker Creation Setup View Configuration
    
    private func setupNavigationBar() {
        title = isHabit ? "Новая привычка" : "Новое нерегулярное событие"
    }
    
    private func setupViewComponents() {
        setupTrackerNameTextField()
        setupTableView()
        // setupEmojiCollectionView()
        // setupColorCollectionView()
        setupCreateTrackerButton()
        setupCancelButton()
    }
    
    private func setupTrackerNameTextField() {
        trackerNameTextField.placeholder = "Введите название трекера"
        trackerNameTextField.clearButtonMode = .whileEditing
        trackerNameTextField.backgroundColor = .ypBackground
        trackerNameTextField.textColor = .ypBlack
        trackerNameTextField.font = UIFont.systemFont(ofSize: ViewConfigurationConstants.fieldFontSize)
        trackerNameTextField.leftViewMode = .always
        trackerNameTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: trackerNameTextField.frame.height))
        trackerNameTextField.keyboardType = .default
        trackerNameTextField.returnKeyType = .default
        trackerNameTextField.addTarget(self, action: #selector(setTrackerName), for: .editingDidEndOnExit)
        
        trackerNameTextField.layer.masksToBounds = true
        trackerNameTextField.layer.cornerRadius = ViewConfigurationConstants.elementsCornerRadius
        
        trackerNameTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(trackerNameTextField)
        
        NSLayoutConstraint.activate([
            trackerNameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            trackerNameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            trackerNameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            trackerNameTextField.heightAnchor.constraint(equalToConstant: 75)
        ])
    }
    
    private func setupTableView() {
        trackerCategoryAndScheduleTableView.delegate = self
        trackerCategoryAndScheduleTableView.dataSource = self
        
        trackerCategoryAndScheduleTableView.backgroundColor = .ypBackground
        trackerCategoryAndScheduleTableView.rowHeight = ViewConfigurationConstants.tableViewRowHeight
        
        trackerCategoryAndScheduleTableView.layer.masksToBounds = true
        trackerCategoryAndScheduleTableView.layer.cornerRadius = ViewConfigurationConstants.elementsCornerRadius
        
        trackerCategoryAndScheduleTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(trackerCategoryAndScheduleTableView)
        
        NSLayoutConstraint.activate([
            trackerCategoryAndScheduleTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            trackerCategoryAndScheduleTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            trackerCategoryAndScheduleTableView.topAnchor.constraint(equalTo: trackerNameTextField.bottomAnchor, constant: 24),
            trackerCategoryAndScheduleTableView.heightAnchor.constraint(equalToConstant: isHabit ? ViewConfigurationConstants.tableViewRowHeight * 2 : ViewConfigurationConstants.tableViewRowHeight)
        ])
    }
    
    private func setupEmojiCollectionView() {
        emojiCollectionView.backgroundColor = .ypWhite
        
        emojiCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emojiCollectionView)
        
        NSLayoutConstraint.activate([
            emojiCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            emojiCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            emojiCollectionView.topAnchor.constraint(equalTo: trackerCategoryAndScheduleTableView.bottomAnchor, constant: 50)
        ])
    }
    
    private func setupColorCollectionView() {
        colorCollectionView.backgroundColor = .ypWhite
        
        colorCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(colorCollectionView)
        
        NSLayoutConstraint.activate([
            colorCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            colorCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            colorCollectionView.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor, constant: 34),
            colorCollectionView.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: 16)
        ])
    }
    
    private func setupCreateTrackerButton(){
        createTrackerButton.setTitle("Создать", for: .normal)
        createTrackerButton.setTitleColor(.ypWhite, for: .normal)
        createTrackerButton.titleLabel?.font = UIFont.systemFont(ofSize: ViewConfigurationConstants.buttonFontSize)
        createTrackerButton.backgroundColor = .ypGray
        
        createTrackerButton.isEnabled = false
        createTrackerButton.addTarget(self, action: #selector(createTrackerButtonDidTape), for: .touchUpInside)
        
        createTrackerButton.layer.masksToBounds = true
        createTrackerButton.layer.cornerRadius = ViewConfigurationConstants.elementsCornerRadius
        
        createTrackerButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(createTrackerButton)
        
        NSLayoutConstraint.activate([
            createTrackerButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 4),
            createTrackerButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            createTrackerButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            createTrackerButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupCancelButton() {
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.setTitleColor(.ypRed, for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: ViewConfigurationConstants.buttonFontSize)
        cancelButton.backgroundColor = .ypWhite
        
        cancelButton.isEnabled = true
        cancelButton.addTarget(self, action: #selector(cancelButtonDidTape), for: .touchUpInside)
        
        cancelButton.layer.masksToBounds = true
        cancelButton.layer.cornerRadius = ViewConfigurationConstants.elementsCornerRadius
        cancelButton.layer.borderWidth = ViewConfigurationConstants.buttonBorderWight
        cancelButton.layer.borderColor = UIColor.ypRed.cgColor
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cancelButton)
        
        NSLayoutConstraint.activate([
            cancelButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -4),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            cancelButton.heightAnchor.constraint(equalToConstant: ViewConfigurationConstants.buttonHeight)
        ])
    }
    
    // MARK: - Actions
    
    @objc
    private func createTrackerButtonDidTape() {
        let newTracker = Tracker(id: UUID(),
                                 name: newTrackerName ?? "",
                                 color: newTrackerColor ?? .clear,
                                 emoji: newTrackerEmoji ?? "",
                                 schedule: newTrackerSchedule)
        self.dismiss(animated: true)
    }
    
    @objc
    private func cancelButtonDidTape() {
        self.dismiss(animated: true)
    }
    
    @objc
    private func setTrackerName(_ sender: UITextField) {
        if sender.text?.isEmpty != nil {
            newTrackerName = sender.text ?? ""
        }
        isTrackerDataReady()
    }
}

// MARK: - TableView Extensions

extension TrackerCreationSetupViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isHabit ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        cell.textLabel?.text = indexPath.row == 0 ? "Категория" : "Расписание"
        cell.textLabel?.textColor = .ypBlack
        cell.textLabel?.font = UIFont.systemFont(ofSize: ViewConfigurationConstants.tableFontSize)
        cell.detailTextLabel?.textColor = .ypGray
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: ViewConfigurationConstants.tableFontSize)
        cell.backgroundColor = .clear
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        
        switch indexPath.row {
        case 0:
            cell.detailTextLabel?.text = "" // TODO: - Add category value in subtitle
        case 1:
            if newTrackerSchedule.count == 7 {
                cell.detailTextLabel?.text = "Каждый день"
            } else {
                cell.detailTextLabel?.text = shortSchedule
            }
        default:
            break
        }
        
        return cell
    }
}

extension TrackerCreationSetupViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let vc = TrackerCategoryChoiceAndCreationViewController()
            let navigationController = UINavigationController(rootViewController: vc)
            self.present(navigationController, animated: true)
        } else {
            let vc = TrackerScheduleViewController()
            let navigationController = UINavigationController(rootViewController: vc)
            self.present(navigationController, animated: true)
        }
    }
}

// MARK: - TextField Extension

extension TrackerCreationSetupViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 38
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)

        return newString.count <= maxLength
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}

// MARK: - ScheduleViewControllerDelegate Extension

extension TrackerCreationSetupViewController: ScheduleViewControllerDelegate {
    
    func saveTrackerSchedule(schedule: [WeekDay]) {
        newTrackerSchedule = schedule
        shortSchedule = {
            let shortScheduleArray = schedule.map { $0.shortName }
            let scheduleRow = shortScheduleArray.joined(separator: ", ")
            return scheduleRow
        }()
        isTrackerDataReady()
    }
}
