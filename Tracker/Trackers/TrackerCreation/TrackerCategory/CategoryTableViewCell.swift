import UIKit

final class CategoryTableViewCell: UITableViewCell {
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        backgroundColor = .ypBackground
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func configure(with viewModel: CategoryTableViewCellModel) {
        textLabel?.text = viewModel.text
        textLabel?.textColor = .ypBlack
        textLabel?.font = UIFont.systemFont(ofSize: ViewConfigurationConstants.tableFontSize)
        
        if viewModel.shouldMakeCornerRadius {
            layer.masksToBounds = true
            layer.cornerRadius = ViewConfigurationConstants.elementsCornerRadius
            layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        }
        
        if viewModel.shouldSetCheckmark {
            accessoryType = .checkmark
        }
    }
}
