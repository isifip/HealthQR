//
//  Common.swift
//  HealthQR
//
//  Created by Irakli Sokhaneishvili on 26.02.22.
//

import Foundation
import UIKit

class Common {
    static let sharedInstance: Common = {
        let instance = Common()
        
        return instance
    }()
    
    static func getDocumentsDirectoryAppend(text: String) -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory.appendingPathComponent(text)
    }
}
