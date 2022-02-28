//
//  HeaderView.swift
//  HealthQR
//
//  Created by Irakli Sokhaneishvili on 28.02.22.
//

import UIKit

class HeaderView: UIView {
    
    @IBOutlet var showDateOfBirth: UIImageView!
    
    private func loadNib() {
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: Bundle(for: type(of: self)))
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.backgroundColor = .clear
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.topAnchor),
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    @objc func showDateOfBirthTapped() {
        print("Show/hide dob")
    }
    
    func setup() {
        loadNib()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showDateOfBirthTapped))
        showDateOfBirth.addGestureRecognizer(tapGesture)
        showDateOfBirth.isUserInteractionEnabled = true
        
        showDateOfBirth.image = UserDefaults.standard.bool(forKey: Constants.SETTINGS_HIDE_DATEOFBIRTH) ? UIImage(named: "eye") : UIImage(named: "eye_hide")
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
