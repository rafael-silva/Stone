import UIKit
import RxSwift
import RxCocoa

final class FactListSearchViewController: UIViewController {
    
    //MARK: Life IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Properties
    
    private let disposeBag = DisposeBag()
    private let viewModel = FactListViewModel(worker: FactListWorker())
    private var searchController: CustomSearchController!
    
    private var categories: [Category] = []
    
    //MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableView?.dataSource = self
        //tableView?.delegate = self
        tableView.separatorStyle = .none
        
        configureSearchController()
        
        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func loadData() {
        //TODOs: ler o arquivo do view model category
    }
    
    private func configureSearchController() {
        searchController = CustomSearchController(searchResultsController: self,
                                                  searchBarFrame: CGRect(x: 0.0, y: 0.0,
                                                                         width: tableView.frame.size.width, height: 50.0),
                                                  searchBarFont: UIFont.boldSystemFont(ofSize: 14),
                                                  searchBarTextColor: .lightGray,
                                                  searchBarTintColor: .white)
        
        searchController.customSearchBar?.placeholder = "Enter your search term"
        tableView.tableHeaderView = searchController?.customSearchBar
        
        searchController?.customSearchDelegate = self
        
    }
}

extension FactListSearchViewController: CustomSearchControllerDelegate {
    
    func didTouchOnSearchButton(_ searchBar: UISearchBar) {
        viewModel.output.facts.drive(onNext: { facts in
            print(facts)
        }).disposed(by: disposeBag)
        viewModel.input.textInput.accept(searchBar.text)
        viewModel.input.reload.accept(())
    }
    
}
