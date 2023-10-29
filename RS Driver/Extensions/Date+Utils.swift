//
//  Date+Utils.swift
//  RS Driver
//
//  Created by Filip Karas on 26/03/2023.
//

import Foundation

extension Date {
    
    public func dateTimeString(dateFormat: String = "dd.MM.yyyy HH:mm:ss") -> String? {
        return self.dateString(dateFormat: dateFormat)
    }
    
    public func dateString(dateFormat: String = "dd.MM.yyyy") -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self)
    }
    
    public func timeString(dateFormat: String = "HH:mm") -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self)
    }
    
    public var utc: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        let d = dateFormatter.string(from: self)
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.date(from: d)
    }
    
    public var gmt: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        let d = dateFormatter.string(from: self)
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        return dateFormatter.date(from: d)
    }
    
    public func stripTime() -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        let date = Calendar.current.date(from: components)
        return date!
    }
}
