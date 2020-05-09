import UIKit

final class CategoryCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = nil
        titleLabel.textColor = .white
        titleLabel.font = .boldSystemFont(ofSize: 14)
    }

    func configure(with text: String) {
        titleLabel.text = text
    }
}
