//
//  MedicineEntity.swift
//  MedAlert
//
//  Created by Anastasia N.  on 06.05.2025.
//

import Foundation
import CoreData

extension MedicineEntity {
    
    var type: MedicineForm {
        get {
            MedicineForm(rawValue: self.type_ ?? "") ?? .tablet
        }
        set {
            self.type_ = newValue.rawValue
        }
    }
    
    var doseType: DoseType {
        get {
            DoseType(rawValue: self.doseType_ ?? "") ?? .tablet
        }
        set {
            self.doseType_ = newValue.rawValue
        }
    }
    
    var intakeType: IntakeType {
        get {
            IntakeType(rawValue: self.intakeType_ ?? "") ?? .anyTime
        }
        set {
            self.intakeType_ = newValue.rawValue
        }
    }
    
    var reminderOffsetType: ReminderOffsetType {
        get {
            ReminderOffsetType(rawValue: self.reminderOffsetType_) ?? .atMoment
        }
        set {
            self.reminderOffsetType_ = newValue.rawValue
        }
    }
    
    var intakeDays: [Weekday] {
        get {
            intakeDays_?.split(separator: ",").compactMap { Weekday(rawValue: Int($0) ?? -1)} ?? []
        }
        
        set {
            intakeDays_ = newValue.compactMap { String($0.rawValue) }.joined(separator: ",")
        }
    }
    
    var scheduledIntakes: [ScheduledIntakeEntity] {
        get {
            scheduledIntakes_?.toTypedArray() ?? []
        }
        set {
            scheduledIntakes_ = NSSet(array: newValue)
        }
    }

}

extension MedicineEntity {
    
    static func makeMedicineEntity(item: MedicineDraftItem, context: NSManagedObjectContext) {
        let newEntity = MedicineEntity(context: context)
        
        newEntity.type = item.type
        newEntity.name = item.name
        newEntity.doseType = item.doseType
        newEntity.comment = item.comment
        newEntity.endDate = item.endDate
        newEntity.intakeDays = item.intakeDays
        newEntity.intakeType = item.intakeType
        newEntity.reminderOffsetType = item.reminderType
        newEntity.doseValue = Int32(item.doseAmount) ?? 1
        newEntity.startDate = item.startDate
        newEntity.scheduledIntakes = item.intakes.map { makeIntake(item: $0, parent: newEntity, context: context) }
        
    }
    
    static func makeIntake(item: MedicineDraftItem.MedicineDraftIntake, parent: MedicineEntity, context: NSManagedObjectContext) -> ScheduledIntakeEntity {
        let newEntity = ScheduledIntakeEntity(context: context)
        newEntity.time = item.time
        newEntity.medicine = parent
        return newEntity
    }
}
