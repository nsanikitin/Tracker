import UIKit

protocol EmojiAndColorCellViewDelegate: AnyObject {
    
    func setEmojiToNewTracker(with emoji: String)
    func setColorToNewTracker(with color: UIColor)
}

final class EmojiAndColorCellView: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "cell"
    
    private let emojiCornerRadius: CGFloat = 16
    private let colorViewCornerRadius: CGFloat = 8
    private let colorViewBorderWight: CGFloat = 3
    
    private lazy var emojiLabel = UILabel()
    private lazy var colorView = UIView()
    private lazy var selectView = UIView()
    
    weak var delegate: EmojiAndColorCellViewDelegate?
    
    // MARK: - Methods
    
    func selectEmoji() {
        selectView.backgroundColor = .ypLightGray
        selectView.layer.cornerRadius = emojiCornerRadius
        
        delegate?.setEmojiToNewTracker(with: emojiLabel.text ?? "")
    }
    
    func deselectEmoji() {
        selectView.backgroundColor = .clear
        selectView.layer.cornerRadius = .zero
    }
    
    func selectColor() {
        selectView.layer.borderColor = colorView.backgroundColor?.withAlphaComponent(0.3).cgColor
        selectView.layer.cornerRadius = colorViewCornerRadius
        selectView.layer.borderWidth = colorViewBorderWight
        
        delegate?.setColorToNewTracker(with: colorView.backgroundColor ?? .clear)
    }
    
    func deselectColor() {
        selectView.layer.borderColor = .none
        selectView.layer.cornerRadius = .zero
        selectView.layer.borderWidth = .zero
    }
    
    // MARK: - Cell View Configuration
    
    func setupSelectView() {
        selectView.backgroundColor = .clear
        
        selectView.layer.masksToBounds = true
        
        selectView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(selectView)
        
        NSLayoutConstraint.activate([
            selectView.heightAnchor.constraint(equalToConstant: 52),
            selectView.widthAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    func setupEmojiLabel(with emoji: String) {
        emojiLabel.text = emoji
        emojiLabel.font = UIFont.systemFont(ofSize: 32)
        emojiLabel.textAlignment = .center
        emojiLabel.backgroundColor = .clear
        
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        selectView.addSubview(emojiLabel)
        
        NSLayoutConstraint.activate([
            emojiLabel.heightAnchor.constraint(equalToConstant: 38),
            emojiLabel.widthAnchor.constraint(equalToConstant: 32),
            emojiLabel.centerXAnchor.constraint(equalTo: selectView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: selectView.centerYAnchor)
        ])
    }
    
    func setupColorView(with color: UIColor) {
        colorView.backgroundColor = color
        
        colorView.layer.masksToBounds = true
        colorView.layer.cornerRadius = colorViewCornerRadius
        
        colorView.translatesAutoresizingMaskIntoConstraints = false
        selectView.addSubview(colorView)
        
        NSLayoutConstraint.activate([
            colorView.heightAnchor.constraint(equalToConstant: 40),
            colorView.widthAnchor.constraint(equalToConstant: 40),
            colorView.centerXAnchor.constraint(equalTo: selectView.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: selectView.centerYAnchor)
        ])
    }
}
