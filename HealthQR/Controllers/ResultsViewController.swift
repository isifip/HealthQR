//
//  ResultsViewController.swift
//  HealthQR
//
//  Created by Irakli Sokhaneishvili on 28.02.22.
//

import UIKit

class ResultsViewController: UIViewController {

    var shcresults: SmartHealthCardResults?
    var entries: Array<Entry> = Array<Entry>()
    
    @IBOutlet var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }
    
}

extension ResultsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VaccineCell", for: indexPath) as! VaccineTableViewCell
        let entry = entries[indexPath.section]
        
        guard let lotNumber = entry.resource.lotNumber else {
            return cell
        }
        guard let issuer = entry.resource.performer?.first?.actor?.display else {
            return cell
        }
        guard let vaccineCode = entry.resource.vaccineCode?.coding?.first?.code else {
            return cell
        }
        
        // go to our database manager to look up the cvx code
        // and we can set the manufacturer label to the vaccine description
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return entries.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
}


