//
//  ReminderOffsetType.swift
//  MedAlert
//
//  Created by Anastasia N.  on 05.05.2025.
//

import Foundation

/// Вид напоминания (задержка в минутах до события)
enum ReminderOffsetType: Int16, Codable {
    case atMoment = 0       // В момент события
    case minutes10 = 10   // За 10 минут
    case minutes15 = 15   // За 15 минут
    case minutes30 = 30   // За 30 минут
    case minutes60 = 60   // За 60 минут (1 час)
}

