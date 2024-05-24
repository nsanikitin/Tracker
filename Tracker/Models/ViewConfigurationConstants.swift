import UIKit

public enum ViewConfigurationConstants {
    
    static let labelFontSize: CGFloat = 12
    static let fieldFontSize: CGFloat = 17
    static let tableFontSize: CGFloat = 17
    static let buttonFontSize: CGFloat = 16

    static let elementsCornerRadius: CGFloat = 16
    
    static let buttonBorderWight: CGFloat = 1

    static let buttonHeight: CGFloat = 60
    static let tableViewRowHeight: CGFloat = 75
    static let textFieldRowHeight: CGFloat = 75
    static let collectionViewTrackerSectionHeight: CGFloat = 148
    static let collectionViewEmojiAndColorHeight: CGFloat = 52
    
    static let collectionViewSectionQuantityForTracker: CGFloat = 2
    static let collectionViewDistanceBetweenSectionsForTracker: CGFloat = 9
    static let collectionViewSectionQuantityForEmojiAndColor: CGFloat = 6
    static let collectionViewDistanceBetweenSectionsForEmojiAndColor: CGFloat = 5
    
    static let trackerEmojis: [String] = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱",
        "😇", "😡", "🥶", "🤔", "🙌", "🍔",
        "🥦", "🏓", "🥇", "🎸", "🏝", "😪"
    ]
    static let trackerColors: [UIColor] = [
        .color1, .color2, .color3, .color4, .color5, .color6,
        .color7, .color8, .color9, .color10, .color11, .color12,
        .color13, .color14, .color15, .color16, .color17, .color18
    ]
}
