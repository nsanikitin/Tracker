import UIKit

protocol TrackerCategoryCreationViewControllerDelegate: AnyObject {
    
    func updateCategoriesList()
}

final class TrackerCategoryCreationViewController: UIViewController {
    
    // MARK: - Properties
    
    private let trackerCategoryStore = TrackerCategoryStore.shared
    
    private lazy var categoryNameTextField = {
        let categoryName = UITextField()
        categoryName.placeholder = "Введите название категории"
        categoryName.textColor = .ypBlack
        categoryName.font = UIFont.systemFont(ofSize: ViewConfigurationConstants.fieldFontSize)
        categoryName.leftViewMode = .always
        categoryName.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: categoryName.frame.height))
        categoryName.backgroundColor = .ypBackground
        categoryName.clearButtonMode = .whileEditing
        
        categoryName.addTarget(self, action: #selector(setCategoryName), for: .editingDidEndOnExit)
        
        return categoryName
    }()
    private lazy var isReadyButton = {
        let button = UIButton()
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: ViewConfigurationConstants.buttonFontSize)
        button.backgroundColor = .ypGray
        
        button.isEnabled = false
        button.addTarget(self, action: #selector(isReadyButtonDidTap), for: .touchUpInside)
        
        return button
    }()
    
    weak var delegate: TrackerCategoryCreationViewControllerDelegate?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        setupNavigationBar()
        setupIsReadyButton()
        setupCategoryNameTextField()
    }
    
    // MARK: - Tracker Category Creation View Configuration
    
    private func setupNavigationBar() {
        title = "Новая категория"
    }
    
    private func setupCategoryNameTextField() {
        categoryNameTextField.delegate = self
        
        categoryNameTextField.layer.masksToBounds = true
        categoryNameTextField.layer.cornerRadius = ViewConfigurationConstants.elementsCornerRadius
        
        categoryNameTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(categoryNameTextField)
        
        NSLayoutConstraint.activate([
            categoryNameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            categoryNameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            categoryNameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            categoryNameTextField.heightAnchor.constraint(equalToConstant: ViewConfigurationConstants.textFieldRowHeight)
        ])
    }
    
    private func setupIsReadyButton() {
        isReadyButton.layer.masksToBounds = true
        isReadyButton.layer.cornerRadius = ViewConfigurationConstants.elementsCornerRadius
        
        isReadyButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(isReadyButton)
        
        NSLayoutConstraint.activate([
            isReadyButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            isReadyButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            isReadyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            isReadyButton.heightAnchor.constraint(equalToConstant: ViewConfigurationConstants.buttonHeight)
        ])
    }

    // MARK: -  Actions
    
    @objc
    private func isReadyButtonDidTap() {
        trackerCategoryStore.addTrackerCategoryToCoreData(categoryTitle: categoryNameTextField.text ?? "")
        delegate?.updateCategoriesList()
        self.dismiss(animated: true)
    }
    
    @objc
    private func setCategoryName() {
        if categoryNameTextField.text != nil {
            isReadyButton.isEnabled = true
            isReadyButton.backgroundColor = .ypBlack
        }
    }
}

// MARK: - TextField Extension

extension TrackerCategoryCreationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
