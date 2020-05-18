extension Collection {
    func choose(_ n: Int) -> ArraySlice<Element> { shuffled().prefix(n) }
}

extension RangeReplaceableCollection {
   
    var shuffled: Self {
        var elements = self
        return elements.shuffledInPlace()
    }
    
    @discardableResult
    mutating func shuffledInPlace() -> Self  {
        indices.dropLast().forEach {
            let subSequence = self[$0...$0]
            let distance = self.distance(from: startIndex, to: $0)
            let index = self.index(indices[..<self.index(endIndex, offsetBy: -distance)].randomElement()!, offsetBy: distance)
            replaceSubrange($0...$0, with: self[index...index])
            replaceSubrange(index...index, with: subSequence)
        }
        return self
    }
    
    func choose(_ n: Int) -> SubSequence { shuffled.prefix(n) }
}
