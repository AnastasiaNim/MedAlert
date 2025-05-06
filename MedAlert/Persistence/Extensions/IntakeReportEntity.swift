//
//  IntakeReportEntity.swift
//  MedAlert
//
//  Created by Anastasia N.  on 06.05.2025.
//

import Foundation
import CoreData

extension IntakeReportEntity {
    
    
    func updateReport(isTaken: Bool,
                      isMissed: Bool,
                      context: NSManagedObjectContext) {
        self.isTaken = isTaken
        self.isMissed = isMissed
        try? context.save()
    }
    
    static func createReport(date: Date,
                             isTaken: Bool,
                             isMissed: Bool,
                             intake: ScheduledIntakeEntity,
                             context: NSManagedObjectContext) {
        
        let new = IntakeReportEntity(context: context)
        
        new.date = date
        new.isMissed = isMissed
        new.isTaken = isTaken
        new.intake = intake
    }
    
}
