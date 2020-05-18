import UIKit

protocol CategoryCustomCellDelegate: class {
    func didTouchOnCategory(_ text: String)
}

final class CategoryCustomCell: UITableViewCell {
    
    //MARK: IBOutlets
    
    @IBOutlet private weak var collectionView: UICollectionView!
    weak var delegate: CategoryCustomCellDelegate?

    //MARK: Properties
    
    private var categoryList = [FactCategory]()
    
    //MARK: Public Methods
    
    func configure(with categoryList: [FactCategory]) {
        self.categoryList = categoryList
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
    }
}

//MARK: - UICollectionViewDataSource

extension CategoryCustomCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CategoryCollectionCell
        
        cell.configure(with: categoryList[indexPath.row].category)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let text = categoryList[indexPath.row].category
        let cellWidth = text.size(withAttributes:[.font: UIFont.systemFont(ofSize:12.0)]).width + 30.0
        
        return CGSize(width: cellWidth, height: 30.0)
    }
}

//MARK: - UICollectionViewDelegate

extension CategoryCustomCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didTouchOnCategory(categoryList[indexPath.row].category)
    }
}

