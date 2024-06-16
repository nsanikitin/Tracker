import UIKit

final class StatisticViewController: UIViewController {
    
    // MARK: - Properties
    
    private let trackerStoreRecord = TrackerRecordStore.shared
    
    private lazy var statisticStubLabel = UILabel()
    private lazy var statisticStubImageView = UIImageView()
    private lazy var completedTrackersLabel = UILabel()
    private lazy var completedTrackersQuantityLabel = UILabel()
    private lazy var gradientFrameView = UIView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        setupNavigationBar()
        setupViewComponents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateStatistic()
    }
    
    // MARK: - Methods
    
    private func updateStatistic() {
        if trackerStoreRecord.trackersRecordCoreData.count != 0 {
            setupCompletedTrackersQuantityLabel()
        }
    }
    
    private func hideStatisticStubs() {
        statisticStubLabel.isHidden = true
        statisticStubImageView.isHidden = true
    }
    
    private func hideStatistic() {
        completedTrackersLabel.isHidden = true
        completedTrackersQuantityLabel.isHidden = true
        gradientFrameView.isHidden = true
    }
    
    // MARK: - Statistic View Configuration
    
    private func setupViewComponents() {
        if trackerStoreRecord.trackersRecordCoreData.count != 0 {
            setupGradientFrameView()
            setupCompletedTrackersQuantityLabel()
            setupCompletedTrackersLabel()
            hideStatisticStubs()
        } else {
            setupStatisticStubImageView()
            setupStatisticStubLabel()
            hideStatistic()
        }
    }
    
    private func setupNavigationBar() {
        title = "Статистика"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupGradientFrameView() {
        gradientFrameView.backgroundColor = .clear
        gradientFrameView.clipsToBounds = true
        
        gradientFrameView.layer.masksToBounds = true
        gradientFrameView.layer.cornerRadius = ViewConfigurationConstants.elementsCornerRadius
        gradientFrameView.layer.borderWidth = 1
        
        let gradient = CAGradientLayer()
        gradient.frame = gradientFrameView.bounds
        gradient.colors = [UIColor.red.cgColor, UIColor.green.cgColor, UIColor.blue.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        
        let shape = CAShapeLayer()
        shape.lineWidth = 1
        shape.path = UIBezierPath(roundedRect: gradientFrameView.bounds, cornerRadius: gradientFrameView.layer.cornerRadius).cgPath
        shape.strokeColor = UIColor.ypBlack.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape

        gradientFrameView.layer.addSublayer(gradient)
        
        gradientFrameView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gradientFrameView)
        
        NSLayoutConstraint.activate([
            gradientFrameView.heightAnchor.constraint(equalToConstant: 90),
            gradientFrameView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -126),
            gradientFrameView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            gradientFrameView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupCompletedTrackersQuantityLabel() {
        completedTrackersQuantityLabel.text = String(describing: trackerStoreRecord.trackersRecordCoreData.count)
        completedTrackersQuantityLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        completedTrackersQuantityLabel.textColor = .ypBlack
        completedTrackersQuantityLabel.isHidden = false
        
        completedTrackersQuantityLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(completedTrackersQuantityLabel)
        
        NSLayoutConstraint.activate([
            completedTrackersQuantityLabel.topAnchor.constraint(equalTo: gradientFrameView.topAnchor, constant: 12),
            completedTrackersQuantityLabel.bottomAnchor.constraint(equalTo: gradientFrameView.bottomAnchor, constant: -37),
            completedTrackersQuantityLabel.leadingAnchor.constraint(equalTo: gradientFrameView.leadingAnchor, constant: 12),
            completedTrackersQuantityLabel.trailingAnchor.constraint(equalTo: gradientFrameView.trailingAnchor, constant: -12)
        ])
    }
    
    private func setupCompletedTrackersLabel() {
        completedTrackersLabel.text = "Трекеров завершено"
        completedTrackersLabel.font = UIFont.systemFont(ofSize: ViewConfigurationConstants.labelFontSize, weight: .semibold)
        completedTrackersLabel.textColor = .ypBlack
        completedTrackersLabel.isHidden = false
        
        completedTrackersLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(completedTrackersLabel)
        
        NSLayoutConstraint.activate([
            completedTrackersLabel.heightAnchor.constraint(equalToConstant: 18),
            completedTrackersLabel.topAnchor.constraint(equalTo: completedTrackersQuantityLabel.bottomAnchor, constant: 7),
            completedTrackersLabel.leadingAnchor.constraint(equalTo: completedTrackersQuantityLabel.leadingAnchor),
            completedTrackersLabel.trailingAnchor.constraint(equalTo: completedTrackersQuantityLabel.trailingAnchor)
        ])
    }
    
    private func setupStatisticStubLabel() {
        statisticStubLabel.text = "Анализировать пока нечего"
        statisticStubLabel.font = UIFont.systemFont(ofSize: ViewConfigurationConstants.labelFontSize)
        statisticStubLabel.textColor = .ypBlack
        statisticStubLabel.isHidden = false
        
        statisticStubLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statisticStubLabel)
        
        NSLayoutConstraint.activate([
            statisticStubLabel.topAnchor.constraint(equalTo: statisticStubImageView.bottomAnchor, constant: 8),
            statisticStubLabel.centerXAnchor.constraint(equalTo: statisticStubImageView.centerXAnchor)
        ])
    }
    
    private func setupStatisticStubImageView() {
        statisticStubImageView.image = UIImage(named: "noStatistic")
        statisticStubImageView.isHidden = false
        
        statisticStubImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statisticStubImageView)
        
        NSLayoutConstraint.activate([
            statisticStubImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            statisticStubImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
}
