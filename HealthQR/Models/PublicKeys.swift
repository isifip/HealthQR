//
//  PublicKeys.swift
//  HealthQR
//
//  Created by Irakli Sokhaneishvili on 27.02.22.
//

import Foundation


struct PublicKeys: Codable {
    let keys: [Key]
}

struct Key: Codable {
    let alg: String
    let kty: String?
    let kid: String?
    let use: String?
    let crv: String?
    let x: String?
    let y: String?
}
