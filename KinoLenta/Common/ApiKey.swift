//
//  LoadApiKey.swift
//  KinoLenta
//
//  Created by Mikhail Kuimov on 16.12.2021.
//

import UIKit

enum ApiKey {
    static var value: String {
        if let filepath = Bundle.main.path(forResource: "api-key", ofType: "txt") {
            do {
                return try String(contentsOfFile: filepath).replacingOccurrences(of: "\n", with: "")
                
            } catch {
                fatalError("token could not be loaded")
            }
        }
        return ""
    }
}
