//
//  NSSet.swift
//  MedAlert
//
//  Created by Anastasia N.  on 05.05.2025.
//

import Foundation

extension NSSet {
    func toTypedArray<ElementType>()-> [ElementType] {
        (allObjects as? [ElementType]) ?? []
    }
}
