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
    
    static func loadJSON(fromURLString urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        if let url = URL(string: urlString) {
            let urlSession = URLSession(configuration: .default).dataTask(with: url) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                }
                if let data = data {
                    completion(.success(data))
                }
            }
            urlSession.resume()
        }
            
    }
    
    
    static func daysBetween(start: Date, end: Date) -> Int {
        let start = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: start)!
        let end = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: end)!
        return Calendar.current.dateComponents([.day], from: start, to: end).day ?? 0
        
    }
}
