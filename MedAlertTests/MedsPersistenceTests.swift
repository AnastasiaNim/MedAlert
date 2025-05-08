//
//  MedsTimeTests.swift
//  MedsTimeTests
//
//  Created by Bogdan Zykov on 05.05.2025.
//

import XCTest
import CoreData
@testable import MedAlert

final class MedsPersistenceTests: XCTestCase {

    let context = PersistenceController.shared.container.viewContext
    
    override func tearDownWithError() throws {
        let _ = try? context.execute(NSBatchDeleteRequest(fetchRequest: MedicineEntity.fetchRequest()))
        let _ = try? context.execute(NSBatchDeleteRequest(fetchRequest: IntakeReportEntity.fetchRequest()))
        let _ = try? context.execute(NSBatchDeleteRequest(fetchRequest: ScheduledIntakeEntity.fetchRequest()))
    }

    func testCorrectCreateMedicineObjects() throws {
        
        try createMedicineObjects()
        
        let mockObjects = MedicineDraftItem.medicinesForTest
        
        let bdObjects = try context.fetch(MedicineEntity.fetchRequest())
        
        XCTAssertEqual(mockObjects.count, bdObjects.count)
        
        let sortedMock = mockObjects.sorted { $0.name < $1.name }
        let sortedActual = bdObjects.sorted { ($0.name ?? "") < ($1.name ?? "") }
        
        for (mock, actual) in zip(sortedMock, sortedActual) {
            XCTAssertEqual(mock.name, actual.name, "Имя не совпадает")
            XCTAssertEqual(mock.type, actual.type, "Тип не совпадает")
            XCTAssertEqual(Int32(mock.doseAmount), actual.doseValue, "Доза не совпадает")
            XCTAssertEqual(mock.doseType, actual.doseType, "Тип дозы не совпадает")
            XCTAssertEqual(mock.intakeType, actual.intakeType, "Тип приёма не совпадает")
            XCTAssertEqual(mock.comment, actual.comment, "Комментарий не совпадает")
            XCTAssertEqual(mock.reminderType, actual.reminderOffsetType, "Напоминание не совпадает")
            XCTAssertEqual(mock.intakeDays, actual.intakeDays, "Дни приёма не совпадают")
            XCTAssertEqual(mock.startDate.timeIntervalSince1970, actual.startDate!.timeIntervalSince1970, accuracy: 1, "Дата начала не совпадает")
            XCTAssertEqual(mock.endDate.timeIntervalSince1970, actual.endDate!.timeIntervalSince1970, accuracy: 1, "Дата окончания не совпадает")
            XCTAssertEqual(mock.intakes.count, actual.scheduledIntakes.count, "Кол-во приёмов не совпадает")
            
            let sortedMockIntakes = mock.intakes.sorted { ($0.time) < ($1.time) }
            let sortedActualIntakes = actual.scheduledIntakes.sorted { ($0.time ?? Date()) < ($1.time ?? Date()) }
            
            for (mockIntake, actualIntake) in zip(sortedMockIntakes, sortedActualIntakes) {
                
                let mockIntakeComponents = mockIntake.time.components([.hour, .minute])
                let actualIntakeComponents = actualIntake.time!.components([.hour, .minute])
 
                XCTAssertEqual(
                    actualIntakeComponents.hour,
                    mockIntakeComponents.hour,
                    "Час приёма не совпадает"
                )
                
                XCTAssertEqual(
                    actualIntakeComponents.minute,
                    mockIntakeComponents.minute,
                    "Минуты приёма не совпадает"
                )
            }
        }
    }
    
    func testFetchIntakesForToday() throws {
        
        let mockItems = MedicineDraftItem.medicinesForTest
        
        try createMedicineObjects()
        
        let todayIntakes = ScheduledIntakeEntity.fetchIntakesForDay(context: context)
        
        let todayWeekDay = Date().weekday()!
        
        let expectedIntakeTimes = mockItems
            .filter({ $0.intakeDays.contains(todayWeekDay)})
            .flatMap { $0.intakes.map { $0.time } }
        
        XCTAssertEqual(todayIntakes.count, expectedIntakeTimes.count, "Количество приёмов за сегодня должно совпадать")
        
        for actual in todayIntakes {
            let hasMatchingTime = expectedIntakeTimes.contains {
                $0.isSameHourAndMinute(as: actual.time!, calendar: .gmt)
            }
            XCTAssertTrue(todayWeekDay == todayIntakes.first?.time?.weekday(), "Несовпадают дни недели")
            XCTAssertTrue(hasMatchingTime, "Не найден приём в мок-данных с временем \(actual.time!)")
        }
    }

    func testCorrectCreateIntakeReportEntity() throws {
        
        try createMedicineObjects()
        
        try context.save()
        
        let objectIntake = try context.fetch(MedicineEntity.fetchRequest()).first!.scheduledIntakes.first!
        
        let createDate = Date.now
        let isTaken = true
        let isMissed = false
        
        objectIntake.addNewRepot(isTaken: isTaken, isMissed: isMissed, date: createDate)
        
        let newIntake = try context.fetch(IntakeReportEntity.fetchRequest()).first!
        
        XCTAssertEqual(isTaken, newIntake.isTaken)
        XCTAssertEqual(isMissed, newIntake.isMissed)
        
        XCTAssertEqual(
            createDate.timeIntervalSince1970,
            newIntake.date!.timeIntervalSince1970,
            accuracy: 1
        )
    }
    
    func testCorrectUpdateIntakeReportEntity() throws {
        try createMedicineObjects()
        
        let objectIntake = try context.fetch(MedicineEntity.fetchRequest()).first!.scheduledIntakes.first!
        
        objectIntake.addNewRepot(isTaken: false, isMissed: false, date: .now)
        
        let intake = try context.fetch(IntakeReportEntity.fetchRequest()).first!

        XCTAssertEqual(intake.isTaken, false)
        
        objectIntake.updateRepot(for: intake, isTaken: true, isMissed: false)
    
        XCTAssertEqual(intake.isTaken, true)
        
    }
    
    private func createMedicineObjects() throws {
        MedicineDraftItem.medicinesForTest.forEach { draft in
            MedicineEntity.makeMedicineEntity(item: draft, context: context)
        }
        try context.save()
    }
}

private extension MedicineDraftItem {
    static let medicinesForTest: [MedicineDraftItem] = [
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
            type: .liquid,
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
}


