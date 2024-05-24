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
    
    private lazy var emojiLabel = {
        let emoji = UILabel()
        emoji.font = UIFont.systemFont(ofSize: 32)
        emoji.textAlignment = .center
        emoji.backgroundColor = .clear
        
        emoji.translatesAutoresizingMaskIntoConstraints = false
        selectView.addSubview(emoji)
        
        NSLayoutConstraint.activate([
            emoji.heightAnchor.constraint(equalToConstant: 38),
            emoji.widthAnchor.constraint(equalToConstant: 32),
            emoji.centerXAnchor.constraint(equalTo: selectView.centerXAnchor),
            emoji.centerYAnchor.constraint(equalTo: selectView.centerYAnchor)
        ])
        return emoji
    }()
    private lazy var colorView = {
        let color = UIView()
        color.layer.masksToBounds = true
        color.layer.cornerRadius = colorViewCornerRadius
        
        color.translatesAutoresizingMaskIntoConstraints = false
        selectView.addSubview(color)
        
        NSLayoutConstraint.activate([
            color.heightAnchor.constraint(equalToConstant: 40),
            color.widthAnchor.constraint(equalToConstant: 40),
            color.centerXAnchor.constraint(equalTo: selectView.centerXAnchor),
            color.centerYAnchor.constraint(equalTo: selectView.centerYAnchor)
        ])
        return color
    }()
    private lazy var selectView = UIView()
    
    weak var delegate: EmojiAndColorCellViewDelegate?
    
    override var isSelected: Bool {
        didSet {
            if !emojiLabel.isHidden {
                isSelected ? deselectEmoji() : selectEmoji()
            }
            if !colorView.isHidden {
                isSelected ? deselectColor() : selectColor()
            }
        }
    }
    
    // MARK: - Methods
    
    func selectEmoji() {
        selectView.backgroundColor = .ypLightGray
        selectView.layer.borderWidth = .zero
        selectView.layer.cornerRadius = emojiCornerRadius
        
        delegate?.setEmojiToNewTracker(with: emojiLabel.text ?? "")
    }
    
    func deselectEmoji() {
        selectView.backgroundColor = .clear
        selectView.layer.cornerRadius = .zero
    }
    
    func selectColor() {
        selectView.backgroundColor = .clear
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
    }
    
    func setupColorView(with color: UIColor) {
        colorView.backgroundColor = color
    }
}
