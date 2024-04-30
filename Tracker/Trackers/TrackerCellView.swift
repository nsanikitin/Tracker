import UIKit

final class TrackerCellView: UICollectionViewCell {
    
    // MARK: - Properties
    
    private let emojiLabel = UILabel()
    private let nameLabel = UILabel()
    private let daysCounterLabel = UILabel()
    private let completedTrackButton = UIButton()
    private let trackColorView = UIView()
    private let currentDate = Date()
    private let TrackersVC = TrackersViewController()
    
    private var daysCounter: Int = 0
    private var isTrackerCompleted: Bool = false
    
    // MARK: - Methods
    
    func setupTrackerCell(tracker: Tracker) {
        setupTrackColorView(with: tracker.color)
        setupEmojiLabel(with: tracker.emoji)
        setupNameLabel(with: tracker.name)
        setupDaysCounterLabel()
        setupCompletedTrackButton(with: tracker.color)
    }
    
    private func setupDaysCounter(for number: Int) {
        switch number % 100 {
        case 1:
            daysCounterLabel.text = "\(number) день"
        case 2...4:
            daysCounterLabel.text = "\(number) дня"
        default:
            daysCounterLabel.text = "\(number) дней"
        }
    }
    
    private func setupCompletedTrack() {
        if isTrackerCompleted {
            completedTrackButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
            completedTrackButton.backgroundColor = completedTrackButton.backgroundColor?.withAlphaComponent(0.3)
        } else {
            completedTrackButton.setImage(UIImage(systemName: "plus"), for: .normal)
            completedTrackButton.backgroundColor = completedTrackButton.backgroundColor?.withAlphaComponent(1)
        }
    }
    
    // MARK: - Cell View Configuration

    private func setupTrackColorView(with color: UIColor) {
        trackColorView.backgroundColor = color
        
        trackColorView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(trackColorView)
        
        trackColorView.layer.masksToBounds = true
        trackColorView.layer.cornerRadius = 16
        
        NSLayoutConstraint.activate([
            trackColorView.widthAnchor.constraint(equalToConstant: 167),
            trackColorView.heightAnchor.constraint(equalToConstant: 90)
        ])
    }
    
    private func setupEmojiLabel(with emoji: String) {
        emojiLabel.text = emoji
        emojiLabel.font = UIFont.systemFont(ofSize: 16)
        emojiLabel.textAlignment = .center
        emojiLabel.backgroundColor = .ypWhite.withAlphaComponent(0.3)
        
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(emojiLabel)
        
        emojiLabel.layer.masksToBounds = true
        emojiLabel.layer.cornerRadius = 12
        
        NSLayoutConstraint.activate([
            emojiLabel.topAnchor.constraint(equalTo: trackColorView.topAnchor, constant: 12),
            emojiLabel.leadingAnchor.constraint(equalTo: trackColorView.leadingAnchor, constant: 12),
            emojiLabel.heightAnchor.constraint(equalToConstant: 24),
            emojiLabel.widthAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    private func setupNameLabel(with name: String) {
        nameLabel.text = name
        nameLabel.font = UIFont.systemFont(ofSize: 12)
        nameLabel.textColor = .ypWhite
        nameLabel.textAlignment = .left
        nameLabel.numberOfLines = 2
        nameLabel.lineBreakMode = .byWordWrapping
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: trackColorView.leadingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: trackColorView.trailingAnchor, constant: 12)
        ])
    }
    
    private func setupDaysCounterLabel(){
        setupDaysCounter(for: daysCounter)
        daysCounterLabel.font = UIFont.systemFont(ofSize: 12)
        daysCounterLabel.textColor = .ypBlack
        
        daysCounterLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(daysCounterLabel)
        
        NSLayoutConstraint.activate([
            daysCounterLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            daysCounterLabel.centerYAnchor.constraint(equalTo: completedTrackButton.centerYAnchor)
        ])
    }
    
    private func setupCompletedTrackButton(with color: UIColor) {
        setupCompletedTrack()
        completedTrackButton.backgroundColor = color
        completedTrackButton.tintColor = .ypWhite
        completedTrackButton.addTarget(self, action: #selector(completedTrackButtonDidTape), for: .touchUpInside)
        
        completedTrackButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(completedTrackButton)
        
        completedTrackButton.layer.masksToBounds = true
        completedTrackButton.layer.cornerRadius = 17
        
        NSLayoutConstraint.activate([
            completedTrackButton.topAnchor.constraint(equalTo: trackColorView.bottomAnchor, constant: 8),
            completedTrackButton.trailingAnchor.constraint(equalTo: trackColorView.trailingAnchor, constant: -12),
            completedTrackButton.heightAnchor.constraint(equalToConstant: 34),
            completedTrackButton.widthAnchor.constraint(equalToConstant: 34)
        ])
    }
    
    // MARK: - Actions
    
    @objc
    private func completedTrackButtonDidTape() {
        guard currentDate > TrackersVC.selectedDate else { return }
        
        if isTrackerCompleted {
            daysCounter -= 1
        } else {
            daysCounter += 1
        }
        
        isTrackerCompleted = !isTrackerCompleted
        setupDaysCounter(for: daysCounter)
        setupCompletedTrack()
    }
}
