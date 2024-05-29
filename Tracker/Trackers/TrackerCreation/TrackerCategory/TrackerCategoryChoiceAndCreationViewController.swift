import UIKit

final class TrackerCategoryChoiceAndCreationViewController: UIViewController {
    
    // MARK: - Properties
    
    private let categoryViewModel: CategoryViewModel
    
    private lazy var addCategoryButton = UIButton()
    private lazy var categoryStubLabel = UILabel()
    private lazy var categoryStubImageView = UIImageView()
    private lazy var categoriesListTableView = UITableView()
    
    // MARK: - Init
    
    init(categoryViewModel: CategoryViewModel) {
        self.categoryViewModel = categoryViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        setupNavigationBar()
        setupAddCategoryButton()
        setupViewComponents()
    }
    
    // MARK: - Methods
    
    private func updateCategoriesList() {
        categoryViewModel.categories = { [weak self] categories in
            self?.setupViewComponents()
        }
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
        categoryViewModel.fetchTrackerCategoriesFromCoreData()
        if categoryViewModel.categoriesCoreData.isEmpty {
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
        
        categoriesListTableView.backgroundColor = .clear
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
            categoriesListTableView.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor, constant: -27)
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
        updateCategoriesList()
        let navigationController = UINavigationController(rootViewController: vc)
        self.present(navigationController, animated: true)
    }
}

// MARK: - TableView Extensions

extension TrackerCategoryChoiceAndCreationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categoryViewModel.categoriesCoreData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CategoryTableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let model = categoryViewModel.viewModelsCells[indexPath.row]
        cell.configure(with: model)
        
        return cell
    }
}

extension TrackerCategoryChoiceAndCreationViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        categoryViewModel.selectCategory(with: categoryViewModel.categoriesCoreData[indexPath.row])
        self.dismiss(animated: true)
    }
}

// MARK: - TrackerCategoryCreationViewControllerDelegate Extension

extension TrackerCategoryChoiceAndCreationViewController: TrackerCategoryCreationViewControllerDelegate {
    func updateCategories(with categoryTitle: String) {
        categoryViewModel.updateCategories(with: categoryTitle)
    }
}
