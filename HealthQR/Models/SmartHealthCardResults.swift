//
//  SmartHealthCardResults.swift
//  HealthQR
//
//  Created by Irakli Sokhaneishvili on 28.02.22.
//

import Foundation

enum VerificationStatus: Codable {
    case VERIFIED, PARTIALLY_VERIFIED, NOT_VERIFIED
}

class SmartHealthCardResults {
    var varificationStatus: VerificationStatus = .NOT_VERIFIED
    var statusText: String = Constants.VERIFICATION_STATUS_NOT_VERIFIED
    var statusMessage: String = Constants.VERIFICATION_STATUS_MESSAGE_NOT_VERIFIED
    var immunizationEntries: Array<Entry> = Array<Entry>()
    var birthDate: String = ""
    var patientName: String = ""
    var iss: String = ""
    
    
    func getPatientName() -> String {
        return patientName
    }
    
    func getBirthDate() -> String {
        return birthDate
    }
    
    func getBirthDateFormatted() -> String {
        var formattedDOB = birthDate
        let userDefaults = UserDefaults.standard
        let hideDOB = userDefaults.bool(forKey: Constants.SETTINGS_HIDE_DATEOFBIRTH)
        
        if hideDOB == true {
            formattedDOB = String(birthDate.map { _ in return "●"})
        }
        return formattedDOB
    }
}
