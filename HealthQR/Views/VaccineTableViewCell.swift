//
//  VaccineTableViewCell.swift
//  HealthQR
//
//  Created by Irakli Sokhaneishvili on 01.03.22.
//

import UIKit

class VaccineTableViewCell: UITableViewCell {
    
    
    @IBOutlet var manufacturerLabel: UILabel!
    @IBOutlet var lotNumberLabel: UILabel!
    @IBOutlet var issuerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
