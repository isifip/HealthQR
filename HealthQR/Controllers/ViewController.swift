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
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "resultsViewController") as? ResultsViewController else {
            print("not working")
            return
        }
        self.present(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.title = "Verifier"
        
    }


}




