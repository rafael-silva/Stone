import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    let disposeBag = DisposeBag()
   // let viewModel = FactListViewModel(worker: FactListWorker())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        viewModel.output.facts.drive(onNext: { facts in print(facts) }).disposed(by: disposeBag)
//        viewModel.input.textInput.accept("car")
//        viewModel.input.reload.accept(())
        
        
    }
}
