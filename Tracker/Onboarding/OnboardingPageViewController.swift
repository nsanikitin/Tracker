import UIKit

final class OnboardingPageViewController: UIViewController {
    
    // MARK: - Properties
    
    private var screenImage: UIImage
    private var labelText: String
    
    private lazy var imageView = UIImageView()
    private lazy var label = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textColor = .ypBlack
        label.numberOfLines = 2
        label.textAlignment = .center
        
        return label
    }()
    
    // MARK: - Init
    
    init(screenImage: UIImage, labelText: String) {
        self.screenImage = screenImage
        self.labelText = labelText
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupImage(with: screenImage)
        setupLabel(with: labelText)
    }
    
    // MARK: - Onboarding Page View Configuration
    
    private func setupImage(with image: UIImage) {
        imageView.image = image
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupLabel(with text: String) {
        label.text = text
        
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -270),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}
