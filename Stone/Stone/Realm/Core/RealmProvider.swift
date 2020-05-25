import Foundation
import RealmSwift

struct RealmProvider {
    
    //MARK: Stored Properties
    
    let configuration: Realm.Configuration
    
    //MARK: Init
    
    /// Initialise RealmProvider
    /// - Parameter config: Storage Configuration
    internal init(config: Realm.Configuration) {
        configuration = config
    }
    
    //MARK: Init
    
    private var realm: Realm? {
        do {
            return try Realm(configuration: configuration)
        } catch {
            debugPrint(error.localizedDescription)
            return nil
        }
    }
    
    //MARK: - Configuration
    
    private static let defaultConfig = Realm.Configuration(schemaVersion: 1)
    private static let mainConfig = Realm.Configuration(
        fileURL:  URL.inDocumentsFolder(fileName: "main.realm"),
        schemaVersion: 1)
    
    
    //MARK: - Realm Instances
    
    /// Initialise RealmProvider context
    /// - Parameter `default`: will initialize realm with the defaultConfig instance
    public static var `default`: Realm? = {
        return RealmProvider(config: RealmProvider.defaultConfig).realm
    }()
    
    /// Initialise RealmProvider context
    /// - Parameter `main`: will initialize realm with the mainConfig instance
    public static var main: Realm? = {
        return RealmProvider(config: RealmProvider.mainConfig).realm
    }()
}


