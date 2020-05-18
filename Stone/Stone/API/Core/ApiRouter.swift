import Foundation
import Alamofire

enum ApiRouter: URLRequestConvertible {
    
    //The endpoint name we'll call later
    
    case getFacts(term: String)
    case getCategories
    
    //MARK: - URLRequestConvertible
    
    func asURLRequest() throws -> URLRequest {
        let url = try Constants.baseUrl.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        //Http method
        
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        
        urlRequest.setValue(Constants.ContentType.json.rawValue, forHTTPHeaderField: Constants.HttpHeaderField.acceptType.rawValue)
        urlRequest.setValue(Constants.ContentType.json.rawValue, forHTTPHeaderField: Constants.HttpHeaderField.contentType.rawValue)
        
        //Encoding
        
        let encoding: ParameterEncoding = {
            switch method {
            case .get:
                return URLEncoding.default
            default:
                return JSONEncoding.default
            }
        }()
        
        return try encoding.encode(urlRequest, with: parameters)
    }
    
    //MARK: - HttpMethod
    ///This returns the HttpMethod type. It's used to determine the type if several endpoints are peresent
    
    private var method: HTTPMethod {
        switch self {
        case .getFacts:
            return .get
        case .getCategories:
            return .get
        }
    }
    
    //MARK: - Path
    ///The path is the part following the base url
    
    private var path: String {
        switch self {
        case .getFacts:
            return "search"
        case .getCategories:
            return "categories"
        }
    }
    
    //MARK: - Parameters
    ///This is the queries part, it's optional because an endpoint can be without parameters
    
    private var parameters: Parameters? {
        switch self {
        case .getFacts(let term):
            return [Constants.Parameters.query : term]
        case .getCategories:
            return nil
        }
    }
}
