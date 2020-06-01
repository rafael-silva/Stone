import UIKit
import RxSwift
import RxCocoa

@available(iOS 13.0, *)
final class FactListSearchViewController: UIViewController {
    
    //MARK: Life IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Properties
    
    private let disposeBag = DisposeBag()
    private let viewModel = FactListViewModel(worker: FactListWorker())
    private let viewM = CategoryListViewModel(worker: CategoryListWorker())
    
    private var searchController: CustomSearchController!
    
    private enum SectionType: String {
        case suggestions = "Suggestions"
        case pastSearches = "Past Searches"
    }
    
    private struct Section {
        let type: SectionType
        let items: [String]
    }
    
    private var sections = [Section]()
    
    //MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.separatorStyle = .none
        configureSearchController()
        
        loadData()
    }
    
    private func loadData() {
        
        
        viewM.output.categoryDictionary.drive(onNext: { teste in
            for (key, values) in teste {
                let array = Array(teste)
                print("🇹🇫: \(key)")
                print("🇸🇬: \(values)")

            }
            self.tableView.reloadData()
            
        }).disposed(by: disposeBag)
        
        viewM.output.categories.drive(onNext: { categories in
            self.sections = [Section(type: .suggestions, items: categories.map({$0.category}).unique())]
            self.tableView.reloadData()
            
        }).disposed(by: disposeBag)
        
        viewM.output.pastSearches.drive(onNext: { searches in
            self.sections.append(contentsOf: [Section(type: .pastSearches, items: searches.map({$0.term}).unique())])
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
        
        viewM.output.errorMessage.drive(onNext: { errorMessage in
            self.presentAlert(errorMessage, title: "Ops!")
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

@available(iOS 13.0, *)
extension FactListSearchViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section].type {
        case .suggestions:
            return 1
        case .pastSearches:
            return sections[section].items.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch sections[section].type {
        case .suggestions:
            return sections[section].type.rawValue
        case .pastSearches:
            return sections[section].type.rawValue
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch sections[indexPath.section].type {
        case .suggestions:
            let custonCell = tableView.dequeueReusableCell(withIdentifier: "CategoryCustonCell",
                                                           for: indexPath) as! CategoryCustomCell
            let categories = sections[indexPath.section].items
            custonCell.configure(with: Array(categories.choose(8)))
            custonCell.layoutIfNeeded()
            custonCell.delegate = self
            
            return custonCell
            
        case .pastSearches:
            let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
            
            cell.textLabel?.text = sections[indexPath.section].items[indexPath.row]
            
            return cell
        }
    }
}

@available(iOS 13.0, *)
extension FactListSearchViewController: CustomSearchControllerDelegate {
    
    func didTouchOnSearchButton(_ searchBar: UISearchBar) {
        viewModel.output.facts.drive(onNext: { facts in
            print(facts)
        }).disposed(by: disposeBag)
        viewModel.input.textInput.accept(searchBar.text)
        viewModel.input.reload.accept(())
    }
    
}

@available(iOS 13.0, *)
extension FactListSearchViewController: CategoryCustomCellDelegate {
    
    func didTouchOnCategory(_ text: String) {
        viewModel.output.facts.drive(onNext: { facts in
            print(facts)
        }).disposed(by: disposeBag)
        viewModel.input.textInput.accept(text)
        viewModel.input.reload.accept(())
    }
    
}
