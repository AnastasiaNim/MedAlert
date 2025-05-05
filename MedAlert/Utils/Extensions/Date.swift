//
//  Date.swift
//  MedAlert
//
//  Created by Anastasia N.  on 05.05.2025.
//

import Foundation


extension Date {
    
    func components(_ components: Set<Calendar.Component>) -> DateComponents {
        Calendar.current.dateComponents(components, from: self)
    }
    
    func added(component: Calendar.Component, value: Int) -> Date? {
        Calendar.current.date(byAdding: component, value: value, to: self)
    }
    
    var startOfHour: Date {
        Calendar.current.startOfHour(for: self)
    }
    
    var endOfHour: Date {
        Calendar.current.endOfHour(for: self)
    }
    
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        Calendar.current.endOfDay(for: self)
    }
    
    var startOfWeek: Date {
        Calendar.current.startOfWeek(for: self)
    }
    
    var endOfWeek: Date {
        Calendar.current.endOfWeek(for: self)
    }

    var startOfMonth: Date {
        Calendar.current.startOfMonth(for: self)
    }

    var endOfMonth: Date {
        Calendar.current.endOfMonth(for: self)
    }
    
    var startOfHalfYear: Date {
        let month = Calendar.current.component(.month, from: self)
        if (1...6).contains(month) {
            return self.startOfYear
        } else {
            var components = Calendar.current.dateComponents([.year], from: self)
            components.month = 7
            return Calendar.current.date(from: components)!
        }
    }
    
    var endOfHalfYear: Date {
        startOfHalfYear
            .added(component: .month, value: 6)!
            .added(component: .second, value: -1)!
    }
    
    var currentQuarter: Int {
        Calendar.current.getQuarter(for: self)
    }
    
    var startOfQuarter: Date {
        startOfYear.added(component: .month, value: currentQuarter * 3)!
    }
    
    var endOfQuarter: Date {
        startOfYear
            .added(component: .month, value: currentQuarter * 3 + 3)!
            .added(component: .second, value: -1)!
    }
    
    var startOfYear: Date {
        Calendar.current.startOfYear(for: self)
    }
    
    var endOfYear: Date {
        Calendar.current.endOfYear(for: self)
    }
    
    
    var startOfHourGMT: Date {
        Calendar.gmt.startOfHour(for: self)
    }
    
    var endOfHourGMT: Date {
        Calendar.gmt.endOfHour(for: self)
    }
    
    var startOfDayGMT: Date {
        Calendar.gmt.startOfDay(for: self)
    }

    var endOfDayGMT: Date {
        Calendar.gmt.endOfDay(for: self)
    }
    
    var startOfWeekGMT: Date {
        Calendar.gmt.startOfWeek(for: self)
    }
    
    var endOfWeekGMT: Date {
        Calendar.gmt.endOfWeek(for: self)
    }

    var startOfMonthGMT: Date {
        Calendar.gmt.startOfMonth(for: self)
    }

    var endOfMonthGMT: Date {
        Calendar.gmt.endOfMonth(for: self)
    }
    
    var startOfYearGMT: Date {
        Calendar.gmt.startOfYear(for: self)
    }
    
    var endOfYearGMT: Date {
        Calendar.gmt.endOfYear(for: self)
    }
    
    func days(from date: Date) -> Int {
        Calendar.current.dateComponents([.day], from: date, to: self).day ?? 1
    }
    
    func getHoursAndMinutes() -> (hours: Int, minutes: Int) {
        let components = Calendar.current.dateComponents([.hour, .minute], from: self)
        return (hours: components.hour ?? 0, minutes: components.minute ?? 0)
    }
    
    var countWeeksInMonth: Int {
        Calendar.current.countWeeksInMonth(for: self)
    }
    
    var currentWeekNumberOfMonth: Int {
        Calendar.current.weekNumberOfMonth(for: self)
    }
    
    var currentHalfYear: Int {
        Calendar.current.getHalfYear(for: self)
    }
    
    var isStartOfMonth: Bool {
        self.startOfMonth == self
    }
    
    var isEndOfMonth: Bool {
        self.endOfMonth == self
    }
    
    var isCurrentYear: Bool {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: self)
        return year == calendar.component(.year, from: .now)
    }
}

public extension Calendar {
    init(identifier: Calendar.Identifier, timeZone: TimeZone) {
        self.init(identifier: identifier)
        self.timeZone = timeZone
    }
}

public extension Calendar {
    
    static let gmt = Calendar(identifier: Calendar.current.identifier, timeZone: .init(secondsFromGMT: 0)!)
    
    func startOfHour(for date: Date)-> Date {
        let components = self.dateComponents([.year, .month, .day, .hour], from: date)
        return self.date(from: components)!
    }
    
    func endOfHour(for date: Date)-> Date {
        startOfHour(for: date)
            .added(component: .second, value: -1)!
    }

    func endOfDay(for date: Date)-> Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return self.date(byAdding: components, to: startOfDay(for: date))!
    }
    
    func startOfWeek(for date: Date)-> Date {
        return self.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: date).date!
    }
    
    func endOfWeek(for date: Date)-> Date {
        startOfWeek(for: date)
            .added(component: .day, value: 7)!
            .added(component: .second, value: -1)!
    }

    func startOfMonth(for date: Date)-> Date {
        let components = self.dateComponents([.year, .month], from: date)
        return self.date(from: components)!
    }

    func endOfMonth(for date: Date)-> Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return self.date(byAdding: components, to: startOfMonth(for: date))!
    }
    
    func startOfYear(for date: Date)-> Date {
        let components = self.dateComponents([.year], from: date)
        return self.date(from: components)!
    }
    
    func endOfYear(for date: Date)-> Date {
        startOfYear(for: date)
            .added(component: .year, value: 1)!
            .added(component: .second, value: -1)!
    }
    
    func getQuarter(for date: Date) -> Int {
        (self.component(.month, from: date) - 1) / 3
    }
        
    func countWeeksInMonth(for date: Date) -> Int {
        guard let range = self.range(of: .weekOfMonth, in: .month, for: date) else {
            return 1
        }
        return range.count
    }
    
    func weekNumberOfMonth(for date: Date) -> Int {
        self.dateComponents([.weekOfMonth], from: date).weekOfMonth ?? 0
    }
    
    func getHalfYear(for date: Date) -> Int {
        let month = self.component(.month, from: date)
        return month <= 6 ? 1 : 2
    }
}

extension Date {
    static func todayAt(hour: Int, minute: Int) -> Date {
        Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: Date())!
    }
}
