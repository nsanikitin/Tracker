import UIKit

protocol TrackerCreationSetupViewControllerDelegate: AnyObject {
    
    func updateTrackerCategory(for trackerCategory: TrackerCategory, isHabit: Bool)
}

final class TrackerCreationSetupViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var createTrackerButton = UIButton()
    private lazy var cancelButton = UIButton()
    private lazy var trackerNameTextField = UITextField()
    
    private var trackerCategoryAndScheduleTableView = UITableView()
    private var newTrackerName: String?
    private var newTrackerSchedule: [WeekDay] = []
    private var newTrackerEmoji: String?
    private var newTrackerColor: UIColor?
    private var shortSchedule: String = ""
    
    weak var delegate: TrackerCreationSetupViewControllerDelegate?
    weak var previousVC: UIViewController?
    
    var isHabit: Bool = false
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        setupNavigationBar()
        setupViewComponents()
    }
    
    // MARK: - Methods
    
    private func switchToCategoryOrScheduleViewController(to vc: UIViewController) {
        let navigationController = UINavigationController(rootViewController: vc)
        self.present(navigationController, animated: true)
    }
    
    private func isTrackerDataReady() {
        if isHabit,
           newTrackerName != nil,
           !newTrackerSchedule.isEmpty {
            activateCreateTrackerButton()
        } else {
            if !isHabit,
               newTrackerName != nil {
                activateCreateTrackerButton()
            }
        }
        // TODO: - Add checking emoji, color and category of tracker
        
        return
    }
    
    private func activateCreateTrackerButton() {
        createTrackerButton.isEnabled = true
        createTrackerButton.backgroundColor = .ypBlack
    }
    
    // MARK: - Tracker Creation Setup View Configuration
    
    private func setupNavigationBar() {
        title = isHabit ? "Новая привычка" : "Новое нерегулярное событие"
    }
    
    private func setupViewComponents() {
        setupTrackerNameTextField()
        setupTableView()
        setupCreateTrackerButton()
        setupCancelButton()
    }
    
    private func setupTrackerNameTextField() {
        trackerNameTextField.placeholder = "Введите название трекера"
        trackerNameTextField.textColor = .ypBlack
        trackerNameTextField.font = UIFont.systemFont(ofSize: ViewConfigurationConstants.fieldFontSize)
        trackerNameTextField.leftViewMode = .always
        trackerNameTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: trackerNameTextField.frame.height))
        trackerNameTextField.backgroundColor = .ypBackground
        trackerNameTextField.clearButtonMode = .whileEditing
        
        trackerNameTextField.delegate = self
        trackerNameTextField.addTarget(self, action: #selector(setTrackerName), for: .editingDidEndOnExit)
        
        trackerNameTextField.layer.masksToBounds = true
        trackerNameTextField.layer.cornerRadius = ViewConfigurationConstants.elementsCornerRadius
        
        trackerNameTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(trackerNameTextField)
        
        NSLayoutConstraint.activate([
            trackerNameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            trackerNameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            trackerNameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            trackerNameTextField.heightAnchor.constraint(equalToConstant: ViewConfigurationConstants.textFieldRowHeight)
        ])
    }
    
    private func setupTableView() {
        trackerCategoryAndScheduleTableView.delegate = self
        trackerCategoryAndScheduleTableView.dataSource = self
        
        trackerCategoryAndScheduleTableView.backgroundColor = .ypBackground
        trackerCategoryAndScheduleTableView.rowHeight = ViewConfigurationConstants.tableViewRowHeight
        trackerCategoryAndScheduleTableView.separatorInset =  UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        trackerCategoryAndScheduleTableView.layer.masksToBounds = true
        trackerCategoryAndScheduleTableView.layer.cornerRadius = ViewConfigurationConstants.elementsCornerRadius
        
        trackerCategoryAndScheduleTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(trackerCategoryAndScheduleTableView)
        
        NSLayoutConstraint.activate([
            trackerCategoryAndScheduleTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            trackerCategoryAndScheduleTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            trackerCategoryAndScheduleTableView.topAnchor.constraint(equalTo: trackerNameTextField.bottomAnchor, constant: 24),
            trackerCategoryAndScheduleTableView.heightAnchor.constraint(equalToConstant: isHabit ? ViewConfigurationConstants.tableViewRowHeight * 2 - 1 : ViewConfigurationConstants.tableViewRowHeight - 1)
        ])
    }
    
    private func setupCreateTrackerButton(){
        createTrackerButton.setTitle("Создать", for: .normal)
        createTrackerButton.setTitleColor(.ypWhite, for: .normal)
        createTrackerButton.titleLabel?.font = UIFont.systemFont(ofSize: ViewConfigurationConstants.buttonFontSize)
        createTrackerButton.backgroundColor = .ypGray
        
        createTrackerButton.isEnabled = false
        createTrackerButton.addTarget(self, action: #selector(createTrackerButtonDidTap), for: .touchUpInside)
        
        createTrackerButton.layer.masksToBounds = true
        createTrackerButton.layer.cornerRadius = ViewConfigurationConstants.elementsCornerRadius
        
        createTrackerButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(createTrackerButton)
        
        NSLayoutConstraint.activate([
            createTrackerButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 4),
            createTrackerButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            createTrackerButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            createTrackerButton.heightAnchor.constraint(equalToConstant: ViewConfigurationConstants.buttonHeight)
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
    private func createTrackerButtonDidTap() {
        guard let newTrackerName = newTrackerName
        else {
            assertionFailure("Tracker name is nil")
            return
        }
        
        if !isHabit {
            newTrackerSchedule = WeekDay.allCases
        }
        
        let newTracker = Tracker(id: UUID(),
                                 name: newTrackerName,
                                 color: .color1,
                                 emoji: "🙂",
                                 schedule: newTrackerSchedule)
        
        
        
        // TODO: - Add emoji and color transfer
        let updatingTrackerCategory = TrackerCategory(title: "По умолчанию",
                                                      trackers: [newTracker])
        delegate?.updateTrackerCategory(for: updatingTrackerCategory, isHabit: isHabit)
        self.dismiss(animated: true)
        previousVC?.dismiss(animated: true)
    }
    
    @objc
    private func cancelButtonDidTape() {
        self.dismiss(animated: true)
    }
    
    @objc
    private func setTrackerName() {
        // TODO: - Add a red label about 38 symbols limit
        if trackerNameTextField.text != nil {
            newTrackerName = trackerNameTextField.text ?? ""
            isTrackerDataReady()
        }
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
        
        if indexPath.row == 0 {
            cell.detailTextLabel?.text = "" // TODO: - Add category value in subtitle
        } else {
            if newTrackerSchedule.count == 7 {
                cell.detailTextLabel?.text = "Каждый день"
            } else {
                cell.detailTextLabel?.text = shortSchedule
            }
        }
        
        return cell
    }
}

extension TrackerCreationSetupViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let vc = TrackerCategoryChoiceAndCreationViewController()
            switchToCategoryOrScheduleViewController(to: vc)
        } else {
            let vc = TrackerScheduleViewController()
            switchToCategoryOrScheduleViewController(to: vc)
            vc.delegate = self
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
        trackerCategoryAndScheduleTableView.reloadData()
        isTrackerDataReady()
    }
}
