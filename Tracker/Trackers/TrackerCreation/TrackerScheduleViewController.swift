import UIKit

protocol ScheduleViewControllerDelegate: AnyObject {
    func saveTrackerSchedule(schedule: [WeekDay])
}

final class TrackerScheduleViewController: UIViewController {

    // MARK: - Properties
    
    private let scheduleTableView = UITableView()
    private let completeButton = UIButton()
    private let weekDays = WeekDay.allCases
    
    weak var delegate: ScheduleViewControllerDelegate?
    private var selectedWeekDays: [WeekDay] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        setupNavigationBar()
        setupViewComponents()
    }
    
    // MARK: - Schedule View Configuration
    
    private func setupNavigationBar() {
        title = "Расписание"
    }
    
    private func setupViewComponents() {
        setupCompleteButton()
        setupScheduleTableView()
    }
    
    private func setupScheduleTableView() {
        scheduleTableView.dataSource = self
        
        scheduleTableView.backgroundColor = .ypBackground
        scheduleTableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        scheduleTableView.rowHeight = ViewConfigurationConstants.tableViewRowHeight
        
        scheduleTableView.layer.masksToBounds = true
        scheduleTableView.layer.cornerRadius = ViewConfigurationConstants.elementsCornerRadius
        
        scheduleTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scheduleTableView)
        
        NSLayoutConstraint.activate([
            scheduleTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            scheduleTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            scheduleTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            scheduleTableView.bottomAnchor.constraint(equalTo: completeButton.topAnchor, constant: -47)
        ])
    }
    
    private func setupCompleteButton() {
        completeButton.setTitle("Готово", for: .normal)
        completeButton.setTitleColor(.ypWhite, for: .normal)
        completeButton.titleLabel?.font = UIFont.systemFont(ofSize: ViewConfigurationConstants.buttonFontSize)
        completeButton.backgroundColor = .ypBlack
        
        completeButton.isEnabled = false
        completeButton.addTarget(self, action: #selector(completeButtonDidTape), for: .touchUpInside)
        
        completeButton.layer.masksToBounds = true
        completeButton.layer.cornerRadius = ViewConfigurationConstants.elementsCornerRadius
        
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(completeButton)
        
        NSLayoutConstraint.activate([
            completeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            completeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            completeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            completeButton.heightAnchor.constraint(equalToConstant: ViewConfigurationConstants.buttonHeight)
        ])
    }
    
    // MARK: - Actions
    
    @objc
    private func completeButtonDidTape() {
        delegate?.saveTrackerSchedule(schedule: selectedWeekDays)
        self.dismiss(animated: true)
    }
    
    @objc
    private func switchValueChanged(sender: UISwitch) {
        let selectedWeekDay = weekDays[sender.tag]
        if sender.isOn {
            selectedWeekDays.append(selectedWeekDay)
            completeButton.isEnabled = true
        } else {
            selectedWeekDays.removeAll { $0 == selectedWeekDay }
            if selectedWeekDays.isEmpty {
                completeButton.isEnabled = false
            }
        }
    }
}

// MARK: - Schedule TableView DataSource Extension

extension TrackerScheduleViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weekDays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let scheduleCell = UITableViewCell()
        scheduleCell.textLabel?.text = weekDays[indexPath.row].fullName
        scheduleCell.textLabel?.textColor = .ypBlack
        scheduleCell.textLabel?.font = UIFont.systemFont(ofSize: ViewConfigurationConstants.tableFontSize)
        scheduleCell.backgroundColor = .clear
        
        let switchView = UISwitch()
        switchView.tag = indexPath.row
        switchView.isOn = false
        switchView.onTintColor = .ypBlue
        switchView.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        
        scheduleCell.accessoryView = switchView
        if indexPath.row == weekDays.count - 1 {
            scheduleCell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        }
        
        return scheduleCell
    }
}
