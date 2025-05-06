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
    
    func componentsGTM(_ components: Set<Calendar.Component>) -> DateComponents {
        Calendar.gmt.dateComponents(components, from: self)
    }
    
    func added(component: Calendar.Component, value: Int) -> Date? {
        Calendar.current.date(byAdding: component, value: value, to: self)
    }
    
    var currentWeekDates: [Date] {
        Calendar.current.currentWeekDates
    }
    
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
        
    var endOfDay: Date {
        Calendar.current.endOfDay(for: self)
    }
        
    var startOfDayGMT: Date {
        Calendar.gmt.startOfDay(for: self)
    }

    var endOfDayGMT: Date {
        Calendar.gmt.endOfDay(for: self)
    }
    
    static func todayAt(hour: Int, minute: Int) -> Date {
        Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: Date())!
    }
    
    func weekday(for calendar: Calendar = .current) -> Weekday? {
        let weekdayIndex = calendar.component(.weekday, from: self)
        return Weekday(rawValue: (weekdayIndex - 1) % 7)
    }
    
    func isSameHourAndMinute(as other: Date, calendar: Calendar = .current) -> Bool {
        let components: Set<Calendar.Component> = [.hour, .minute]
        let selfComponents = calendar.dateComponents(components, from: self)
        let otherComponents = calendar.dateComponents(components, from: other)
        return selfComponents.hour == otherComponents.hour &&
               selfComponents.minute == otherComponents.minute
    }
}

extension Calendar {
    
    static let gmt = Calendar(identifier: Calendar.current.identifier, timeZone: .init(secondsFromGMT: 0)!)
    
    func endOfDay(for date: Date)-> Date {
         self.date(byAdding: .day, value: 1, to: startOfDay(for: date))!
    }
   
    var currentWeekDates: [Date] {
        let today = Date()
        let weekday = self.component(.weekday, from: today)

        let shift = (weekday - self.firstWeekday + 7) % 7
        
        guard let startOfWeek = self.date(byAdding: .day, value: -shift, to: today) else {
            return []
        }
        
        return (0..<7).compactMap {
            self.date(byAdding: .day, value: $0, to: startOfWeek)
        }
    }
}

extension Calendar {
    init(identifier: Calendar.Identifier, timeZone: TimeZone) {
        self.init(identifier: identifier)
        self.timeZone = timeZone
    }
}
