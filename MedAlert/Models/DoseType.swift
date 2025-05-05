//
//  DoseType.swift
//  MedAlert
//
//  Created by Anastasia N.  on 05.05.2025.
//

import Foundation

/// Вид дозы (единица измерения дозы)
enum DoseType: String, Codable {
    case tablet       // Таблетка (фиксированная доза в штуках)
    case unit         // Единица (например, капля, таблетка, штука)
    case milligram    // Миллиграмм (mg)
    case gram         // Грамм (g)
}

