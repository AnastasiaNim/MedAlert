//
//  ScheduledIntakeEntity.swift
//  MedAlert
//
//  Created by Anastasia N.  on 06.05.2025.
//

import Foundation
import CoreData

extension ScheduledIntakeEntity {
    
    var reports: [IntakeReportEntity] {
        get {
            reports_?.toTypedArray() ?? []
        }
        set {
            reports_ = NSSet(array: newValue)
        }
    }
    
    func addNewRepot(isTaken: Bool,
                     isMissed: Bool,
                     date: Date = .now) {
        guard let context = managedObjectContext else { return }
        IntakeReportEntity.createReport(date: date, isTaken: isTaken, isMissed: isMissed, intake: self, context: context)
        try? context.save()
    }
    
    func updateRepot(for report: IntakeReportEntity, isTaken: Bool, isMissed: Bool) {
        guard let context = managedObjectContext else { return }
        report.updateReport(isTaken: isTaken, isMissed: isMissed, context: context)
        try? context.save()
    }
}


extension ScheduledIntakeEntity {
    
    static func fetchIntakesForDay(day: Date = .now, context: NSManagedObjectContext) -> [ScheduledIntakeEntity] {
        
        let weekday = String(day.weekday()?.rawValue ?? 0)
        
        let predicate = NSPredicate(
            format: "medicine.startDate <= %@ AND medicine.endDate >= %@ AND medicine.intakeDays_ CONTAINS %@",
            day.endOfDay as NSDate,
            day.startOfDay as NSDate,
            weekday
        )
        
        let request = ScheduledIntakeEntity.fetchRequest()
        request.predicate = predicate
        request.sortDescriptors = [NSSortDescriptor(keyPath: \ScheduledIntakeEntity.time, ascending: true)]
        
        return (try? context.fetch(request)) ?? []
    }
    
}
