//
//  SettingsViewController.swift
//  HealthQR
//
//  Created by Irakli Sokhaneishvili on 26.02.22.
//

import UIKit
import Eureka

class SettingsViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Settings"
        
        
        form +++ Section("About")
        <<< LabelRow() { row in
            row.title = "Version"
            row.value = Common.getAppVersion()
        }
        
        <<< LabelRow() { row in
            row.title = "Privacy Policy"
            
        }.onCellSelection({ cell, row in
            cell.row.deselect()
            Common.openURL(urlString: Constants.PRIVACY_URL)
        }).cellSetup({ cell, row in
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .default
        })
        
        <<< LabelRow() { row in
            row.title = "Terms of Use"
            
        }.onCellSelection({ cell, row in
            cell.row.deselect()
            Common.openURL(urlString: Constants.TERMS_URL)
        }).cellSetup({ cell, row in
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .default
        })
    }
    

}
