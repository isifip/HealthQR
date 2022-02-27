//
//  Extensions.swift
//  HealthQR
//
//  Created by Irakli Sokhaneishvili on 27.02.22.
//

import Foundation
import UIKit

extension String {
    func transformFromNumericMode(every n: Int) -> String {
        var result = ""
        let characters = Array(self)
        for x in stride(from: 0, to: characters.count, by: n) {
            var sub = String(characters[x..<min(x + n, characters.count)])
            let code = Int(sub) ?? 0
            sub = String(format: "%c", code + 45)
            result += sub
        }
        return result
    }
}
