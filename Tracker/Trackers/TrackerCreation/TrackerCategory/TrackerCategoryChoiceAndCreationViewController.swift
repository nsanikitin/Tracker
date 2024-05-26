import UIKit

final class TrackerCategoryChoiceAndCreationViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var addCategoryButton = UIButton()
    private lazy var categoryStubLabel = UILabel()
    private lazy var categoryStubImageView = UIImageView()
    
    private var categoriesListTableView = UITableView()
    private var categoriesCoreData: [TrackerCategoryCoreData] = []
    private var selectedCategoryCoreData: TrackerCategoryCoreData?
    private var categoryViewModel: CategoryViewModel?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        setupNavigationBar()
        setupAddCategoryButton()
    }
    
    // MARK: - Methods
    
    func initialize(viewModel: CategoryViewModel?) {
        categoryViewModel = viewModel
        guard let categoryViewModel = categoryViewModel else { return }
        
        categoryViewModel.selectedCategory = { [weak self] selectedCategory in
            self?.selectedCategoryCoreData = selectedCategory
        }
        
        bind()
    }
    
    private func bind() {
        guard let categoryViewModel = categoryViewModel else { return }
        categoryViewModel.categories = { [weak self] categories in
            self?.categoriesCoreData = categories
            self?.setupViewComponents()
        }
        
        categoryViewModel.fetchTrackerCategoriesFromCoreData()
    }
    
    private func showStubs() {
        setupCategoryStubImageView()
        setupCategoryStubLabel()
    }
    
    private func hideStubs() {
        categoryStubImageView.isHidden = true
        categoryStubLabel.isHidden = true
    }
    
    // MARK: - Category View Configuration
    
    private func setupNavigationBar() {
        title = "Категория"
    }
    
    private func setupViewComponents() {
        if categoriesCoreData.isEmpty {
            showStubs()
        } else {
            hideStubs()
            setupCategoriesListTableView()
            categoriesListTableView.reloadData()
        }
    }
    
    private func setupCategoriesListTableView() {
        categoriesListTableView.delegate = self
        categoriesListTableView.dataSource = self
        
        categoriesListTableView.backgroundColor = .ypBackground
        categoriesListTableView.rowHeight = ViewConfigurationConstants.tableViewRowHeight
        categoriesListTableView.separatorInset =  UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        categoriesListTableView.layer.masksToBounds = true
        categoriesListTableView.layer.cornerRadius = ViewConfigurationConstants.elementsCornerRadius
        
        categoriesListTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(categoriesListTableView)
        
        NSLayoutConstraint.activate([
            categoriesListTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            categoriesListTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            categoriesListTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            categoriesListTableView.heightAnchor.constraint(equalToConstant: CGFloat(categoriesCoreData.count) * ViewConfigurationConstants.tableViewRowHeight - 1)
        ])
    }
    
    private func setupAddCategoryButton() {
        addCategoryButton.setTitle("Добавить категорию", for: .normal)
        addCategoryButton.setTitleColor(.ypWhite, for: .normal)
        addCategoryButton.titleLabel?.font = UIFont.systemFont(ofSize: ViewConfigurationConstants.buttonFontSize)
        addCategoryButton.backgroundColor = .ypBlack
        
        addCategoryButton.isEnabled = true
        addCategoryButton.addTarget(self, action: #selector(addCategoryButtonDidTap), for: .touchUpInside)
        
        addCategoryButton.layer.masksToBounds = true
        addCategoryButton.layer.cornerRadius = ViewConfigurationConstants.elementsCornerRadius
        
        addCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addCategoryButton)
        
        NSLayoutConstraint.activate([
            addCategoryButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addCategoryButton.heightAnchor.constraint(equalToConstant: ViewConfigurationConstants.buttonHeight)
        ])
    }
    
    private func setupCategoryStubImageView() {
        categoryStubImageView.image = UIImage(named: "stub")
        categoryStubImageView.isHidden = false
        
        categoryStubImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(categoryStubImageView)
        
        NSLayoutConstraint.activate([
            categoryStubImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            categoryStubImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    private func setupCategoryStubLabel() {
        categoryStubLabel.text = "Привычки и события можно объединить по смыслу"
        categoryStubLabel.font = UIFont.systemFont(ofSize: ViewConfigurationConstants.labelFontSize, weight: .medium)
        categoryStubLabel.textColor = .ypBlack
        categoryStubLabel.numberOfLines = 2
        categoryStubLabel.isHidden = false
        
        categoryStubLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(categoryStubLabel)
        
        NSLayoutConstraint.activate([
            categoryStubLabel.topAnchor.constraint(equalTo: categoryStubImageView.bottomAnchor, constant: 8),
            categoryStubLabel.centerXAnchor.constraint(equalTo: categoryStubImageView.centerXAnchor)
        ])
    }
    
    // MARK: - Actions
    
    @objc
    private func addCategoryButtonDidTap() {
        let vc = TrackerCategoryCreationViewController()
        vc.delegate = self
        let navigationController = UINavigationController(rootViewController: vc)
        self.present(navigationController, animated: true)
    }
}

// MARK: - TableView Extensions

extension TrackerCategoryChoiceAndCreationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categoriesCoreData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        cell.textLabel?.text = categoriesCoreData[indexPath.row].title
        cell.textLabel?.textColor = .ypBlack
        cell.textLabel?.font = UIFont.systemFont(ofSize: ViewConfigurationConstants.tableFontSize)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        if selectedCategoryCoreData?.title == categoriesCoreData[indexPath.row].title {
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
}

extension TrackerCategoryChoiceAndCreationViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let categoryViewModel = categoryViewModel else { return }
        categoryViewModel.selectCategory(with: categoriesCoreData[indexPath.row])
        self.dismiss(animated: true)
    }
}

// MARK: - TrackerCategoryCreationViewControllerDelegate Extension

extension TrackerCategoryChoiceAndCreationViewController: TrackerCategoryCreationViewControllerDelegate {
    
    func updateCategoriesList() {
        bind()
    }
}
