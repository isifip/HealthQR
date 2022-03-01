//
//  HeaderView.swift
//  HealthQR
//
//  Created by Irakli Sokhaneishvili on 28.02.22.
//

import UIKit

class HeaderView: UIView {
    
    @IBOutlet var showDateOfBirth: UIImageView!
    
    @IBOutlet var statusMessageLabel: UILabel!
    @IBOutlet var fullNameLabel: UILabel!
    @IBOutlet var dateOfBirthLabel: UILabel!
    @IBOutlet var issuerLabel: UILabel!
    
    
    @IBOutlet var statusImageView: UIImageView!
    @IBOutlet var statusTitleLabel: UILabel!
    
    @IBOutlet var HeaderContentView: UIView!
    @IBOutlet var invalidMessageLabel: UILabel!
    
    var dateOfBirth: String = ""
    
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
    
    private func setVerificationStatus(status: VerificationStatus, statusTitle: String, statusMessage: String) {
        let statusColor = Theme.Colors.colorFromVerificationStatus(verificationStatus: status)
        var statusImage: UIImage?
        
        switch status {
        case .VERIFIED:
            invalidMessageLabel.isHidden = true
            HeaderContentView.isHidden = false
            statusImage = UIImage(named: "result_verified")
        case .PARTIALLY_VERIFIED:
            invalidMessageLabel.isHidden = true
            HeaderContentView.isHidden = false
            statusImage = UIImage(named: "result_failed")
        case .NOT_VERIFIED:
            invalidMessageLabel.isHidden = false
            invalidMessageLabel.text = statusMessage
            HeaderContentView.isHidden = true
            statusImage = UIImage(named: "result_invalid")
        }
        
        statusTitleLabel.text = statusTitle
        statusMessageLabel.text = statusMessage
        statusImageView.image = statusImage
        
    }
    
    func populateView(shcresults: SmartHealthCardResults) {
        self.fullNameLabel.text = shcresults.getPatientName()
        self.dateOfBirth = shcresults.getBirthDate()
        self.dateOfBirthLabel.text = shcresults.getBirthDateFormatted()
        self.issuerLabel.text = shcresults.iss
        
        setVerificationStatus(status: shcresults.verificationStatus, statusTitle: shcresults.statusText, statusMessage: shcresults.statusMessage)
        
        self.backgroundColor = Theme.Colors.colorFromVerificationStatus(verificationStatus: shcresults.verificationStatus)
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
