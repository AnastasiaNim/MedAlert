//
//  MedicineType.swift
//  MedAlert
//
//  Created by Anastasia N.  on 05.05.2025.
//

import Foundation

///Форма лекарственного средства
enum MedicineForm: String, Codable {
    case tablet        // Таблетка
    case capsule       // Капсула
    case injection     // Инъекция (укол)
    case drops         // Капли
    case liquid        // Жидкость (суспензия, сироп)
    case topical       // Местное средство: мазь, крем, гель
    case spray         // Спрей
}

