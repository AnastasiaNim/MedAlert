//
//  MedicineItem.swift
//  MedAlert
//
//  Created by Anastasia N.  on 05.05.2025.
//

import Foundation

struct MedicineDraftItem {
    var type: MedicineForm = .tablet
    var name: String = ""
    var doseAmount: String = ""
    var doseType: DoseType = .tablet
    var intakeType: IntakeType = .beforeMeal
    var comment: String = ""
    var reminderType: ReminderOffsetType = .atMoment
    var intakeDays: [Weekday] = Weekday.allCases
    var startDate: Date = .now
    var endDate: Date = .now.added(component: .day, value: 1) ?? .now
    var intakes: [MedicineDraftIntake] = [.init(time: .now)]
    
    var isInfoStepValid: Bool {
        !name.isEmpty && !doseAmount.isEmpty
    }
    
    struct MedicineDraftIntake: Identifiable {
        let id = UUID()
        var time: Date
    }
}


let medicinesForTest: [MedicineDraftItem] = [
    MedicineDraftItem(
        type: .tablet,
        name: "Paracetamol",
        doseAmount: "500",
        doseType: .milligram,
        intakeType: .afterMeal,
        comment: "Take in case of fever",
        reminderType: .minutes15,
        intakeDays: [.monday, .wednesday, .friday],
        startDate: .now,
        endDate: Calendar.current.date(byAdding: .day, value: 7, to: .now) ?? .now,
        intakes: [.init(time: Date.todayAt(hour: 9, minute: 0))]
    ),
    MedicineDraftItem(
        type: .capsule,
        name: "Vitamin D",
        doseAmount: "1",
        doseType: .unit,
        intakeType: .duringMeal,
        comment: "Helps with calcium absorption",
        reminderType: .minutes30,
        intakeDays: [.sunday],
        startDate: .now,
        endDate: Calendar.current.date(byAdding: .month, value: 1, to: .now) ?? .now,
        intakes: [.init(time: Date.todayAt(hour: 12, minute: 0))]
    ),
    MedicineDraftItem(
        type: .drops,
        name: "Eye Drops",
        doseAmount: "2",
        doseType: .unit,
        intakeType: .anyTime,
        comment: "Use in case of dryness",
        reminderType: .atMoment,
        intakeDays: Weekday.allCases,
        startDate: .now,
        endDate: Calendar.current.date(byAdding: .weekOfYear, value: 2, to: .now) ?? .now,
        intakes: [
            .init(time: Date.todayAt(hour: 8, minute: 0)),
            .init(time: Date.todayAt(hour: 20, minute: 0))
        ]
    ),
    MedicineDraftItem(
        type: .spray,
        name: "Nasal Spray",
        doseAmount: "1",
        doseType: .unit,
        intakeType: .beforeMeal,
        comment: "Use before meals if needed",
        reminderType: .minutes10,
        intakeDays: [.tuesday, .thursday],
        startDate: .now,
        endDate: Calendar.current.date(byAdding: .day, value: 10, to: .now) ?? .now,
        intakes: [.init(time: Date.todayAt(hour: 7, minute: 30))]
    ),
    MedicineDraftItem(
        type: .topical,
        name: "Skin Cream",
        doseAmount: "5",
        doseType: .gram,
        intakeType: .anyTime,
        comment: "Apply thin layer to affected area",
        reminderType: .minutes60,
        intakeDays: [.monday, .tuesday, .wednesday, .thursday, .friday],
        startDate: .now,
        endDate: Calendar.current.date(byAdding: .weekOfYear, value: 1, to: .now) ?? .now,
        intakes: [.init(time: Date.todayAt(hour: 21, minute: 0))]
    )
]
