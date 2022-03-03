//
//  Theme.swift
//  HealthQR
//
//  Created by Irakli Sokhaneishvili on 26.02.22.
//

import Foundation
import UIKit

class Theme {
    class Colors {
        
        class func colorFromVerificationStatus(verificationStatus: VerificationStatus) -> UIColor {
            switch verificationStatus {
            case .VERIFIED:
                return Verified()
            case .PARTIALLY_VERIFIED:
                return PartiallyVerified()
            case .NOT_VERIFIED:
                return NotVerified()
            }
        }
        
        class func Verified() -> UIColor {
            return UIColor(red: 16/255, green: 136/255, blue: 72/255, alpha: 1)
        }
        class func PartiallyVerified() -> UIColor {
            return .systemOrange
        }
        
        class func NotVerified() -> UIColor {
            return .systemRed
        }
        
        class func vaccineTitleBackgroundColor() -> UIColor {
            return UIColor(red: 76/255, green: 144/255, blue: 202/255, alpha: 1)
        }
        
        class func navigationBarBackgorundColor() -> UIColor {
            return UIColor(red: 0/255, green: 162/255, blue: 212/255, alpha: 1)
        }
    }
}
