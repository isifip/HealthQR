//
//  SmartHealthCardReader.swift
//  HealthQR
//
//  Created by Irakli Sokhaneishvili on 27.02.22.
//

import Foundation
import UIKit
import JOSESwift
import CryptoKit


class SmartHealthCardReader {
    static let sharedInstance: SmartHealthCardReader = {
        let instance = SmartHealthCardReader()
        
        return instance
    }()
    
    class func shared() -> SmartHealthCardReader {
        return sharedInstance
    }
    
    private func parseJWS(qrCodeString: String) -> JWS? {
        do {
            guard qrCodeString.starts(with: Constants.SMART_HEALTH_CARD_PREFIX) else {
                return nil
            }
            let numbers = qrCodeString.replacingOccurrences(of: Constants.SMART_HEALTH_CARD_PREFIX, with: "")
            let final = numbers.transformFromNumericMode(every: 2)
            let jws = try JWS(compactSerialization: final)
            return jws
        } catch {
            print("Error parsing JWS: \(error.localizedDescription)")
            return nil
        }
    }
    
    func parseSmartHealthCard(qrCodeString: String, completion: @escaping (SmartHealthCard?) ->Void) {
        let shc: SmartHealthCard? = nil
        
        if let jws = parseJWS(qrCodeString: qrCodeString) {
            do {
                let uncompressed = try (jws.payload.data() as NSData).decompressed(using: .zlib)
                guard let str = String.init(data: uncompressed as Data, encoding: .utf8) else {
                    completion(shc)
                    return
                }
                guard let jsonData = str.data(using: .utf8) else {
                    completion(shc)
                    return
                }
                
                let shc = try JSONDecoder().decode(SmartHealthCard.self, from: jsonData)
                
                print(shc.iss)
                completion(shc)
            } catch {
                completion(shc)
            }
        } else {
            completion(shc)
        }
    }
}
