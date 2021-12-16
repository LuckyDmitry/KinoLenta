//
//  LoadApiKey.swift
//  KinoLenta
//
//  Created by Mikhail Kuimov on 16.12.2021.
//

import UIKit

func loadApiKey() -> String {
    var token: String = ""
    if let filepath = Bundle.main.path(forResource: "api-key", ofType: "txt") {
        do {
            token = try String(contentsOfFile: filepath)
            token = token.replacingOccurrences(of: "\n", with: "")
        } catch {
            fatalError("token could not be loaded")
        }
    }
    return token
}
