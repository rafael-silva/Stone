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
    
    private var factsList = [String]()
    
    //MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView.separatorStyle = .none
        
        load()
        configureSearchController()
    }
    
    private func load() {
        factsList = ["primeiro", "segundo", "terceiro", "quarto", "quinto"]
        tableView?.reloadData()
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

extension FactListSearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return factsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "idCell", for: indexPath as IndexPath)
        
        cell.textLabel?.text = factsList[indexPath.row]
        
        return cell
    }
}

extension FactListSearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        //TODOs: Select category
    }
}

