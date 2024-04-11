import UIKit

final class TrackersViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var trackStubLabel: UILabel = UILabel()
    private lazy var trackStubImageView: UIImageView = UIImageView()
    
    private var tracks: Int = 0
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        isTrackListEmpty()
    }
    
    // MARK: - Methods
    
    func isTrackListEmpty() {
        if tracks == 0 {
            setupTrackImageStub()
            setupTrackLabelStub()
        }
    }
    
    // MARK: - View Configuration
    
    func setupTrackImageStub() {
        guard let trackStubImage = UIImage(named: "trackStub") else { return }
        trackStubImageView = UIImageView(image: trackStubImage)
        
        trackStubImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(trackStubImageView)
        
        NSLayoutConstraint.activate([
            trackStubImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            trackStubImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func setupTrackLabelStub() {
        trackStubLabel.text = "Что будем отслеживать?"
        trackStubLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        trackStubLabel.textColor = .ypBlack
        
        trackStubLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(trackStubLabel)
        
        trackStubLabel.topAnchor.constraint(equalTo: trackStubImageView.bottomAnchor, constant: 8).isActive = true
        trackStubLabel.centerXAnchor.constraint(equalTo: trackStubImageView.centerXAnchor).isActive = true
    }
}

