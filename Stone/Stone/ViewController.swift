import UIKit
import RxSwift

class ViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let api = API()
        
        api.getFacts(term: "Car")
            .observeOn(MainScheduler.instance)
            .retry(2)
            .subscribe(onNext: { response in
                let facts = response.result.map { Fact(output: $0) }
                print("List of facts:", facts)
            }, onError: { error in
                switch error {
                case ApiError.conflict:
                    print("Conflict error")
                case ApiError.forbidden:
                    print("Forbidden error")
                case ApiError.notFound:
                    print("Not found error")
                default:
                    print("Unknown error:", error)
                }
            })
            .disposed(by: disposeBag)
    }
}

