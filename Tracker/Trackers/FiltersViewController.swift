import UIKit

protocol FiltersViewControllerDelegate: AnyObject {
    
    func didSelectFilter()
}

final class FiltersViewController: UIViewController {
    
    // MARK: - Properties
    
    private let filters = ["Все трекеры", "Трекеры на сегодня", "Завершенные", "Не завершенные"]
    
    private lazy var filtersTableView = UITableView()
    weak var delegate: FiltersViewControllerDelegate?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        setupNavigationBar()
        setupFiltersTableView()
    }
    
    // MARK: - Filters View Configuration
    
    private func setupNavigationBar() {
        title = "Фильтры"
    }
    
    private func setupFiltersTableView() {
        filtersTableView.delegate = self
        filtersTableView.dataSource = self
        
        filtersTableView.backgroundColor = .clear
        filtersTableView.rowHeight = ViewConfigurationConstants.tableViewRowHeight
        filtersTableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        filtersTableView.layer.masksToBounds = true
        filtersTableView.layer.cornerRadius = ViewConfigurationConstants.elementsCornerRadius
        
        filtersTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filtersTableView)
        
        NSLayoutConstraint.activate([
            filtersTableView.heightAnchor.constraint(equalToConstant: ViewConfigurationConstants.tableViewRowHeight * CGFloat(filters.count)),
            filtersTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            filtersTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            filtersTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
}

// MARK: - Table View Extensions

extension FiltersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaultsStorage().filterType = indexPath.row
        delegate?.didSelectFilter()
        self.dismiss(animated: true)
    }
}

extension FiltersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let filterCell = UITableViewCell()
        filterCell.textLabel?.text = filters[indexPath.row]
        filterCell.textLabel?.textColor = .ypBlack
        filterCell.textLabel?.font = UIFont.systemFont(ofSize: ViewConfigurationConstants.tableFontSize)
        filterCell.backgroundColor = .ypBackground
        filterCell.selectionStyle = .none
        
        if indexPath.row == filters.count - 1 {
            filterCell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        }
        
        if indexPath.row == UserDefaultsStorage().filterType {
            filterCell.accessoryType = .checkmark
        }
        
        return filterCell
    }
}
