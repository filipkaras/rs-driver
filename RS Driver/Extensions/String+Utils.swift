//
//  String+Utils.swift
//  RS Driver
//
//  Created by Filip Karas on 26/03/2023.
//

import Foundation

extension String {

    public enum TruncationPosition {
        case head
        case middle
        case tail
    }
    
    public var lines: [String] {
        var result: [String] = []
        enumerateLines { line, _ in result.append(line) }
        return result
    }
    
    public var url: URL? {
        guard let escaped = self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return nil }
        return URL(string: escaped)
    }
    
    public func truncated(limit: Int, position: TruncationPosition = .tail, leader: String = "...") -> String {
        guard self.count > limit else { return self }
        
        switch position {
        case .head:
            return leader + self.suffix(limit)
        case .middle:
            let headCharactersCount = Int(ceil(Float(limit - leader.count) / 2.0))
            
            let tailCharactersCount = Int(floor(Float(limit - leader.count) / 2.0))
            
            return "\(self.prefix(headCharactersCount))\(leader)\(self.suffix(tailCharactersCount))"
        case .tail:
            return self.prefix(limit) + leader
        }
    }
    
    public func toDateTime(dateFormat: String = "dd.MM.yyyy HH:mm:ss") -> Date? {
        return self.toDate(dateFormat: dateFormat)
    }
    
    public func toDate(dateFormat: String = "dd.MM.yyyy") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.date(from: self)
    }
    
    public func htmlPage() -> String {
        let path = Bundle.main.path(forResource: "page", ofType: "html")
        var HTMLString: String
        HTMLString = try! String(contentsOfFile: path!, encoding: String.Encoding.utf8)
        HTMLString = HTMLString.replacingOccurrences(of: "[CONTENT]", with: self)
        return HTMLString
    }
}

extension StringProtocol {
    
    public func index(of string: Self, options: String.CompareOptions = []) -> Index? {
        return range(of: string, options: options)?.lowerBound
    }
    
    public func endIndex(of string: Self, options: String.CompareOptions = []) -> Index? {
        return range(of: string, options: options)?.upperBound
    }
    
    public func indexes(of string: Self, options: String.CompareOptions = []) -> [Index] {
        var result: [Index] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...].range(of: string, options: options) {
                result.append(range.lowerBound)
                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
    
    public func ranges(of string: Self, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...].range(of: string, options: options) {
                result.append(range)
                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
    
    public func strpos(_ substring: Self) -> Int? {
        guard let index = self.index(of: substring) else { return nil }
        return index.utf16Offset(in: substring)
    }
    
    public func substr(fromIndex: Int, toIndex: Int) -> String? {
        if fromIndex < toIndex && toIndex <= self.count {
            let startIndex = self.index(self.startIndex, offsetBy: fromIndex)
            let endIndex = self.index(self.startIndex, offsetBy: toIndex)
            return String(self[startIndex..<endIndex])
        } else {
            return nil
        }
    }
    
    public func substr(fromIndex: Int, length: Int) -> String? {
        if fromIndex > self.count { return nil }
        return self.substr(fromIndex: fromIndex, toIndex: Swift.min(fromIndex + length, self.count))
    }
}

extension String {
    
    public var isBlank: Bool {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    public var emptyIfNull: String {
        return self
    }
}

extension Optional where Wrapped == String {
    
    public var isBlank: Bool {
        if let unwrapped = self {
            return unwrapped.isBlank
        } else {
            return true
        }
    }
    
    public var url: URL? {
        if let unwrapped = self {
            return unwrapped.url
        } else {
            return nil
        }
    }
    
    public var emptyIfNull: String {
        if let unwrapped = self {
            return unwrapped
        } else {
            return ""
        }
    }
}
