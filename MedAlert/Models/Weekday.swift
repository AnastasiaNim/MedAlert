//
//  Weekday.swift
//  MedAlert
//
//  Created by Anastasia N.  on 05.05.2025.
//

import Foundation

/// Дни недели для приема (понедельник = 0)
enum Weekday: Int, CaseIterable {
    case monday = 0, tuesday, wednesday, thursday, friday, saturday, sunday
    
    /// Возвращает список дней недели в порядке, соответствующем `calendar.firstWeekday`.
    ///
    /// Например, если первая неделя начинается с понедельника (`firstWeekday = 2`),
    /// возвращаемый порядок будет: `[.monday, .tuesday, ..., .sunday]`.
    ///
    /// - Parameter calendar: Календарь, по которому определяется первый день недели.
    /// - Returns: Отсортированный массив `Weekday` согласно локальным настройкам.
    static func orderedWeekdays(for calendar: Calendar = .current) -> [Weekday] {
        let weekdays = Weekday.allCases
        let shift = max(0, min(calendar.firstWeekday - 1, weekdays.count - 1))
        return Array(weekdays[shift ..< weekdays.count] + weekdays[0 ..< shift])
    }
    
    /// Локализованное имя дня недели с текущим `Calendar`.
    func localized(for calendar: Calendar = .current) -> String? {
        guard calendar.weekdaySymbols.indices.contains(self.rawValue) else {
            return nil
        }
        return calendar.weekdaySymbols[self.rawValue]
    }
    
    var localized: String {
        self.localized() ?? ""
    }
    
    /// Возвращает соответствующее значение дня недели для `Calendar`.
    ///
    /// `Calendar` использует диапазон от 1 (воскресенье) до 7 (суббота),
    /// в то время как `Weekday` использует от 0 до 6. Это свойство преобразует значение в формат `Calendar`.
    var systemWeekday: Int {
        (rawValue + 1) % 7 + 1
    }
}
