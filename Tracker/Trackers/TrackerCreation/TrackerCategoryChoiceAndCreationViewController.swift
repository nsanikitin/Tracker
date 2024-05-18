import UIKit

final class TrackerCategoryChoiceAndCreationViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var addCategoryButton = UIButton()
    private lazy var categoryStubLabel = UILabel()
    
    private lazy var categoryStubImageView = UIView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        setupNavigationBar()
        setupViewComponents()
    }
    
    // MARK: - Category View Configuration
    
    private func setupNavigationBar() {
        title = "Категория"
    }
    
    private func setupViewComponents() {
        setupCategoryStubImageView()
        setupCategoryStubLabel()
        setupAddCategoryButton()
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
        guard let categoryStubImage = UIImage(named: "stub") else { return }
        categoryStubImageView = UIImageView(image: categoryStubImage)
        
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
        // TODO: - Add action to addCategoryButton
    }
}
