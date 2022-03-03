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
    
    
    func sanitizeBase64() -> String {
        var retStr = self.replacingOccurrences(of: "-", with: "+").replacingOccurrences(of: "_", with: "/")
        if retStr.count % 4 == 2 {
            retStr.append("==")
        }
        
        if retStr.count % 4 == 3 {
            retStr.append("=")
        }
        return retStr
    }
    
    
}

extension Data {
    var bytes: [UInt8] {
        return [UInt8](self)
    }
}


extension Date {
    func getFormattedDate(format: String) -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = format
        return dateFormat.string(from: self)
    }
}
