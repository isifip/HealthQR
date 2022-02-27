//
//  CustomButton.swift
//  HealthQR
//
//  Created by Irakli Sokhaneishvili on 27.02.22.
//

import UIKit

@IBDesignable class CustomButton: UIButton {
    
    func setup() {
        self.layer.cornerRadius = 12
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

}
