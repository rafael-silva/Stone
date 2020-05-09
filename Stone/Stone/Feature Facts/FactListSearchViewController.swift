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
    
    private var categories: [FactCategory] = []
    
    //MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        configureSearchController()
        
        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func loadData() {
        let viewM = CategoriesViewModel(worker: CategoriestWorker())
                
        viewM.output.categories.drive(onNext: { categories in
            self.categories = categories
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
        
        viewM.output.errorMessage.drive(onNext: { errorMessage in
        print("❌:\(errorMessage)\n")
        }).disposed(by: disposeBag)
        
        viewM.input.reload.accept(())
    }
    
    private func configureSearchController() {
        searchController = CustomSearchController(searchResultsController: self,
                                                  searchBarFrame: CGRect(x: 0.0, y: 0.0,
                                                                         width: tableView.frame.size.width, height: 50.0),
                                                  searchBarFont: .boldSystemFont(ofSize: 14),
                                                  searchBarTextColor: .lightGray,
                                                  searchBarTintColor: .white)
        
        searchController.customSearchBar?.placeholder = "Enter your search term"
        tableView.tableHeaderView = searchController?.customSearchBar
        
        searchController?.customSearchDelegate = self
        
    }
}

extension FactListSearchViewController: UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCustonCell",
                   for: indexPath) as! CategoryCustomCell
               
        cell.configure(with: Array(categories.choose(8)))
        cell.delegate = self
        
        return cell
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

extension FactListSearchViewController: CategoryCustomCellDelegate {
    func didTouchOnCategory(_ text: String) {
        searchController.customSearchBar.text = text
    }
}
