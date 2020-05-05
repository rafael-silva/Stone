import Alamofire
import RxSwift

protocol ApiProtocol {
    func request<T: Decodable> (_ urlConvertible: URLRequestConvertible) -> Observable<T>
}

class API: ApiProtocol {
    
    //MARK: - The request function to get results in an Observable
    init() {}
    
    func request<T: Decodable> (_ urlConvertible: URLRequestConvertible) -> Observable<T> {
        return Observable<T>.create { observer in
            
            let request = AF.request(urlConvertible).responseDecodable { (response: DataResponse<T, AFError>) in
                
                switch response.result {
                case .success(let value):
                    observer.onNext(value)
                    observer.onCompleted()
                    
                case .failure(let error):
                    switch response.response?.statusCode {
                    case 403:
                        observer.onError(ApiError.forbidden)
                    case 404:
                        observer.onError(ApiError.notFound)
                    case 409:
                        observer.onError(ApiError.conflict)
                    case 500:
                        observer.onError(ApiError.internalServerError)
                    default:
                        observer.onError(ApiError.unknownedError(error.localizedDescription))
                    }
                }
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
