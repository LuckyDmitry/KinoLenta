//
//  LayoutManager.swift
//  KinoLenta
//
//  Created by Dmitry Trifonov on 13.12.2021.
//

import Foundation
import UIKit

protocol LayoutManager {
    associatedtype CellType
    func applyLayout(for cell: CellType, bounds: CGRect)
}

struct AnyLayoutManager<T>: LayoutManager {
    typealias CellType = T
    
    private let applyLayout: (T, CGRect) -> ()
    
    init<Manager: LayoutManager>(_ manager: Manager) where Manager.CellType == T {
        applyLayout = manager.applyLayout
    }
    
    func applyLayout(for cell: T, bounds: CGRect) {
        applyLayout(cell, bounds)
    }
}
