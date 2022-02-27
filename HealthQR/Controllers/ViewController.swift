//
//  ViewController.swift
//  HealthQR
//
//  Created by Irakli Sokhaneishvili on 26.02.22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var btnScan: CustomButton!
    @IBAction func scanButtonTapped(_ sender: Any) {
        print("Scan button tapped")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.title = "Verifier"
        
    }


}

