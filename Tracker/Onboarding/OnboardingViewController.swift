import UIKit

final class OnboardingViewController: UIPageViewController {
    
    // MARK: - Properties
    
    private lazy var userDefaultsStorage = UserDefaultsStorage()
    private lazy var exitButton = {
        let button = UIButton()
        button.backgroundColor = .ypBlack
        button.setTitle("Вот это технологии!", for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: ViewConfigurationConstants.buttonFontSize)
        
        button.addTarget(self, action: #selector(exitButtonDidTap), for: .touchUpInside)
        
        return button
    }()
    private lazy var pages: [UIViewController] = {
        guard let blueImage = UIImage(named: "onboardingScreenPage1"),
              let redImage = UIImage(named: "onboardingScreenPage2") else {
            assertionFailure("Images for pages is not exist!")
            return []
        }
        let bluePage = OnboardingPageViewController(
            screenImage: blueImage,
            labelText: "Отслеживайте только то, что хотите"
        )
        let redPage = OnboardingPageViewController(
            screenImage: redImage,
            labelText: "Даже если это не литры воды и йога"
        )
        
        return [bluePage, redPage]
    }()
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        
        pageControl.currentPageIndicatorTintColor = .ypBlack
        pageControl.pageIndicatorTintColor = .ypBlack.withAlphaComponent(0.3)
        
        return pageControl
    }()
    
    var onboardingIsFinished: (() -> Void)?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        setViewControllers([pages[0]], direction: .forward, animated: true)
        
        setupExitButton()
        setupPageControl()
    }
    
    // MARK: - Onboarding View Configuration
    
    private func setupExitButton() {
        exitButton.layer.masksToBounds = true
        exitButton.layer.cornerRadius = ViewConfigurationConstants.elementsCornerRadius
        
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(exitButton)
        
        NSLayoutConstraint.activate([
            exitButton.heightAnchor.constraint(equalToConstant: ViewConfigurationConstants.buttonHeight),
            exitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            exitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupPageControl() {
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: exitButton.topAnchor, constant: -24)
        ])
    }
    
    // MARK: - Actions
    
    @objc
    private func exitButtonDidTap() {
        userDefaultsStorage.onboardingIsCompleted = true
        onboardingIsFinished?()
        self.dismiss(animated: true)
    }
}

// MARK: - PageViewController Extensions

extension OnboardingViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
    }
}

extension OnboardingViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1

        guard previousIndex >= 0 else {
            return pages.last
        }

        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }

        let nextIndex = viewControllerIndex + 1

        guard nextIndex < pages.count else {
            return pages.first
        }

        return pages[nextIndex]
    }
}
