struct Sorted {
    let key: String
    let ascending: Bool
    
    /// Sort struct
    /// - Parameters:
    ///   - key: key value to be sorted
    ///   - ascending: true if ascending and false if descending
    public init(key: String, ascending: Bool) {
        self.key = key
        self.ascending = ascending
    }
}
