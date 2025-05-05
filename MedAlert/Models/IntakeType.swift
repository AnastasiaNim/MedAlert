//
//  IntakeType.swift
//  MedAlert
//
//  Created by Anastasia N.  on 05.05.2025.
//

import Foundation

/// Вид приема относительно еды
enum IntakeType: String, Codable {
    case beforeMeal   // До еды
    case afterMeal    // После еды
    case duringMeal   // Во время еды
    case anyTime      // В любое время
}
