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
    
    private func getJWKS(issuerURL: String, kid: String, completion: @escaping(Result<Key?, Error>) -> Void){
        var retKey: Key? = nil
        
        Common.loadJSON(fromURLString: issuerURL) { result in
            switch result {
            case .success(let data):
                
                if let content = String(data: data, encoding: .utf8) {
                    do {
                        if let jsonData = content.data(using: .utf8) {
                            let jwksObject = try JSONDecoder().decode(PublicKeys.self, from: jsonData)
                            for key in jwksObject.keys {
                                if let jwksid = key.kid {
                                    if jwksid == kid {
                                        retKey = key
                                        break
                                    }
                                }
                            }
                        }
                        if retKey != nil {
                            completion(.success(retKey))
                        }
                        else {
                            completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Key was not found"])))
                        }
                    }
                    catch{
                        print("Error decoding public keys into JSON: \(error)")
                        completion(.failure(error))
                    }
                }
                break
            case .failure(let error):
                print("Error loading JSON from URL: \(error)")
                completion(.failure(error))
                break
            }
        }
    }
    
    private func generatePublicKey(jws: JWS, key: Key) -> SecKey? {
        var pk: SecKey?
        
        let attributesECPub: [String:Any] = [
            kSecAttrKeyType as String: kSecAttrKeyTypeEC,
            kSecAttrKeyClass as String: kSecAttrKeyClassPublic,
            kSecAttrKeySizeInBits as String: 256
        ]
        
        if var xStr = key.x, var yStr = key.y {
            xStr = xStr.sanitizeBase64()
            yStr = yStr.sanitizeBase64()
            
            if let x:[UInt8] = Data.init(base64Encoded: xStr)?.bytes, let y:[UInt8] = Data.init(base64Encoded: yStr)?.bytes {
                let i : [UInt8] = [0x04]
                
                let pubBytes = i + x + y
                var error: Unmanaged<CFError>?
                pk = SecKeyCreateWithData(Data.init(pubBytes) as CFData, attributesECPub as CFDictionary, &error)! as SecKey
            }
        }
        
        return pk
    }
    
    private func validateJWS(jws: JWS, key: Key) -> Bool {
        var retVal: Bool = false
        
        if let publicKey = generatePublicKey(jws: jws, key: key) {
            if let verifier = Verifier(verifyingAlgorithm: .ES256, key: publicKey) {
            
                do {
                    _ = try jws.validate(using: verifier)
                    retVal = true
                    print("Smart Health Card Cryptographic Signature Verified!")
                }
                catch JOSESwiftError.signatureInvalid {
                    print("Error verifying cryptographic signature")
                }
                catch{
                    print("Unknown error verifying cyrptographic signature \(error)")
                }
            }
        }
        
        return retVal
    }
    
    private func verifySmartHealthCard(jws: JWS, shc: SmartHealthCard, completion: @escaping (Bool) -> Void) {
        let issuerURL = shc.iss + "/.well-known/jwks.json"
        
        guard let kid = jws.header.kid else {
            completion(false)
            return
        }
        
        getJWKS(issuerURL: issuerURL, kid: kid) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let key):
                if let key = key {
                    let valid = self.validateJWS(jws: jws, key: key)
                    completion(valid)
                } else {
                    print("Error retreiving public keys")
                    completion(false)
                }
                break
            case .failure(let error):
                completion(false)
                print("Error retreiving public keys: \(error)")
                break
            }
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
                print(shc)
                verifySmartHealthCard(jws: jws, shc: shc) { success in
                    print("Success: \(success)")
                }
                completion(shc)
            } catch {
                completion(shc)
            }
        } else {
            completion(shc)
        }
    }
}
