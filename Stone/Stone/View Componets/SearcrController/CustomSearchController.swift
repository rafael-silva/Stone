import UIKit

protocol CustomSearchControllerDelegate: class {
    func didTouchOnSearchButton(_ searchBar: UISearchBar)
}

final class CustomSearchController: UISearchController {
    
    var customSearchBar: CustomSearchBar!
    var customSearchDelegate: CustomSearchControllerDelegate?
    
    //MARK: Init
    
    init(searchResultsController: UIViewController, searchBarFrame: CGRect, searchBarFont: UIFont, searchBarTextColor: UIColor, searchBarTintColor: UIColor) {
        super.init(searchResultsController: searchResultsController)
        
        configureSearchBar(frame: searchBarFrame, font: searchBarFont, textColor: searchBarTextColor, bgColor: searchBarTintColor)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: Private Api
    
    private func configureSearchBar(frame: CGRect, font: UIFont,
                                    textColor: UIColor, bgColor: UIColor) {
        customSearchBar = CustomSearchBar(frame: frame)
        
        customSearchBar.barTintColor = bgColor
        customSearchBar.tintColor = textColor
        
        customSearchBar.preferredFont = font
        customSearchBar.preferredTextColor = textColor
        
        customSearchBar.showsCancelButton = false
        customSearchBar?.delegate = self
    }
    
}

// MARK: - UISearchBarDelegate

extension CustomSearchController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        customSearchBar?.resignFirstResponder()
        customSearchDelegate?.didTouchOnSearchButton(searchBar)
    }
}
