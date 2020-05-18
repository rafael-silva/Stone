import UIKit

final class CategoryCollectionCell: UICollectionViewCell {
    
    @IBOutlet private weak var textLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textLabel.text = nil
        textLabel.textColor = .white
        textLabel.font = .boldSystemFont(ofSize: 14)
        layer.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1).cgColor
    }
    
    func configure(with text: String) {
        textLabel.text = text
    }
}
