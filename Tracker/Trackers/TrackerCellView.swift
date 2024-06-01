import UIKit

protocol TrackerCellViewDelegate: AnyObject {
    
    func addCompletedTracker(for trackerID: UUID)
    func removeCompletedTracker(for trackerID: UUID)
    func deleteTrackerFromCoreData(for trackerID: UUID)
    func showEditViewController(with navigationController: UINavigationController)
    func pinOrUnpinTracker(for trackerID: UUID, isPinned: Bool)
}

final class TrackerCellView: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "cell"
    
    private lazy var emojiLabel = UILabel()
    private lazy var nameLabel = UILabel()
    private lazy var daysCounterLabel = UILabel()
    private lazy var completeTrackButton = UIButton()
    private lazy var trackColorView = UIView()
    private lazy var trackerID = UUID()
    
    lazy var trackerSelectedDate = Date()
    lazy var trackerCurrentDate = Date()
    lazy var completedDaysCounter: Int = 0
    lazy var isTrackerCompleted: Bool = false
    
    weak var delegate: TrackerCellViewDelegate?
    
    // MARK: - Methods
    
    func setupTrackerCell(for tracker: Tracker) {
        trackerID = tracker.id
        setupTrackColorView(with: tracker.color)
        setupEmojiLabel(with: tracker.emoji)
        setupNameLabel(with: tracker.name)
        setupDaysCounterLabel()
        setupCompleteTrackButton(with: tracker.color)
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
            completeTrackButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
            completeTrackButton.backgroundColor = completeTrackButton.backgroundColor?.withAlphaComponent(0.3)
        } else {
            completeTrackButton.setImage(UIImage(systemName: "plus"), for: .normal)
            completeTrackButton.backgroundColor = completeTrackButton.backgroundColor?.withAlphaComponent(1)
        }
    }
    
    // MARK: - Cell View Configuration
    
    private func setupTrackColorView(with color: UIColor) {
        trackColorView.backgroundColor = color
        
        trackColorView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(trackColorView)
        
        trackColorView.layer.masksToBounds = true
        trackColorView.layer.cornerRadius = ViewConfigurationConstants.elementsCornerRadius
        
        NSLayoutConstraint.activate([
            trackColorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            trackColorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            trackColorView.heightAnchor.constraint(equalToConstant: 90)
        ])
    }
    
    private func setupEmojiLabel(with emoji: String) {
        emojiLabel.text = emoji
        emojiLabel.textColor = .ypWhite
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
        nameLabel.font = UIFont.systemFont(ofSize: ViewConfigurationConstants.labelFontSize)
        nameLabel.textColor = .ypWhite
        nameLabel.textAlignment = .left
        nameLabel.numberOfLines = 2
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.overrideUserInterfaceStyle = .light
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: trackColorView.leadingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: trackColorView.trailingAnchor, constant: 12),
            nameLabel.bottomAnchor.constraint(equalTo: trackColorView.bottomAnchor, constant: -12)
        ])
    }
    
    private func setupDaysCounterLabel() {
        setupDaysCounter(for: completedDaysCounter)
        daysCounterLabel.font = UIFont.systemFont(ofSize: ViewConfigurationConstants.labelFontSize)
        daysCounterLabel.textColor = .ypBlack
        
        daysCounterLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(daysCounterLabel)
        
        NSLayoutConstraint.activate([
            daysCounterLabel.leadingAnchor.constraint(equalTo: trackColorView.leadingAnchor, constant: 12),
            daysCounterLabel.topAnchor.constraint(equalTo: trackColorView.bottomAnchor, constant: 16)
        ])
    }
    
    private func setupCompleteTrackButton(with color: UIColor) {
        completeTrackButton.backgroundColor = color
        completeTrackButton.tintColor = .ypWhite
        setupCompletedTrack()
        
        completeTrackButton.addTarget(self, action: #selector(completeTrackButtonDidTap), for: .touchUpInside)
        
        completeTrackButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(completeTrackButton)
        
        completeTrackButton.layer.masksToBounds = true
        completeTrackButton.layer.cornerRadius = 17
        
        NSLayoutConstraint.activate([
            completeTrackButton.topAnchor.constraint(equalTo: trackColorView.bottomAnchor, constant: 8),
            completeTrackButton.trailingAnchor.constraint(equalTo: trackColorView.trailingAnchor, constant: -12),
            completeTrackButton.heightAnchor.constraint(equalToConstant: 34),
            completeTrackButton.widthAnchor.constraint(equalToConstant: 34)
        ])
    }
    
    // MARK: - Actions
    
    @objc
    private func completeTrackButtonDidTap() {
        if trackerCurrentDate <= trackerSelectedDate { return }
        
        if isTrackerCompleted {
            completedDaysCounter -= 1
            delegate?.removeCompletedTracker(for: trackerID)
        } else {
            completedDaysCounter += 1
            delegate?.addCompletedTracker(for: trackerID)
        }
        
        isTrackerCompleted = !isTrackerCompleted
        setupDaysCounter(for: completedDaysCounter)
        setupCompletedTrack()
    }
}

// MARK: - Context Menu Extension

extension TrackerCellView {
    
    func configureContextMenu(contextMenuTracker: Tracker, contextMenuCategory: TrackerCategory, isPinned: Bool, isIrregularEvent: Bool, numberOfCompletedDays: Int) -> UIContextMenuConfiguration {
        
        return UIContextMenuConfiguration(actionProvider: { actions in
            return UIMenu(children: [
                UIAction(title: isPinned ? "Открепить" : "Закрепить") { [weak self] _ in
                    self?.delegate?.pinOrUnpinTracker(for: contextMenuTracker.id, isPinned: !isPinned)
                },
                UIAction(title: "Редактировать") { [weak self] _ in
                    let vc = TrackerCreationSetupViewController()
                    vc.isTrackerEditing = true
                    vc.isHabit = isIrregularEvent ? false : true
                    self?.setupDaysCounter(for: numberOfCompletedDays)
                    vc.numberOfCompletedDaysText = self?.daysCounterLabel.text
                    vc.currentTracker = contextMenuTracker
                    vc.currentCategory = contextMenuCategory.title
                    
                    let navigationController = UINavigationController(rootViewController: vc)
                    self?.delegate?.showEditViewController(with: navigationController)
                },
                UIAction(title: "Удалить", attributes: .destructive) { [weak self] _ in
                    self?.delegate?.deleteTrackerFromCoreData(for: contextMenuTracker.id)
                }
            ])
        })
    }
}
