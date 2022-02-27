//
//  SmartHealthCard.swift
//  HealthQR
//
//  Created by Irakli Sokhaneishvili on 27.02.22.
//

import Foundation

// MARK: - Welcome
struct SmartHealthCard: Codable {
    let iss: String
    let nbf: Double
    let vc: VaccineCard
}

// MARK: - Vc
struct VaccineCard: Codable {
    let type: [String]
    let credentialSubject: CredentialSubject
    let rid: String
}

// MARK: - CredentialSubject
struct CredentialSubject: Codable {
    let fhirVersion: String
    let fhirBundle: FhirBundle
}

// MARK: - FhirBundle
struct FhirBundle: Codable {
    let resourceType, type: String
    let entry: [Entry]
}

// MARK: - Entry
struct Entry: Codable {
    let fullURL: String
    let resource: Resource

    enum CodingKeys: String, CodingKey {
        case fullURL = "fullUrl"
        case resource
    }
}

// MARK: - Resource
struct Resource: Codable {
    let resourceType: String
    let name: [Name]?
    let birthDate, status: String?
    let vaccineCode: VaccineCode?
    let patient: Patient?
    let occurrenceDateTime: String?
    let performer: [Performer]?
    let lotNumber: String?
}

// MARK: - Name
struct Name: Codable {
    let family: String?
    let given: [String]?
}

// MARK: - Patient
struct Patient: Codable {
    let reference: String?
}

// MARK: - Performer
struct Performer: Codable {
    let actor: Actor?
}

// MARK: - Actor
struct Actor: Codable {
    let display: String?
}

// MARK: - VaccineCode
struct VaccineCode: Codable {
    let coding: [Coding]?
}

// MARK: - Coding
struct Coding: Codable {
    let system: String?
    let code: String?
}

