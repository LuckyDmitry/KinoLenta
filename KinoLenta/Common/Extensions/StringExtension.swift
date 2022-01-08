//
//  Extension+String.swift
//  KinoLenta
//
//  Created by user on 16.12.2021.
//

import Foundation


extension String {
    var firstUppercased: String { prefix(1).uppercased() + dropFirst() }
}
