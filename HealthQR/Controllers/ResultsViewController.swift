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
    @IBOutlet var headerView: HeaderView!
    
    func setupsUI() {
        if let shcresults = shcresults {
            entries = shcresults.immunizationEntries
            self.headerView.populateView(shcresults: shcresults)
        } else {
            print("Results was nil, it shouldnt happen")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupsUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }
    
}

extension ResultsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let entry = entries[section]
        var doseTitle = ""
        if let dateTimeString = entry.resource.occurrenceDateTime {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let date = dateFormatter.date(from: dateTimeString) {
                doseTitle = "Dose \(section + 1) - \(date.getFormattedDate(format: "MMM d, yyyy"))"
            }
        }
        return doseTitle
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as? UITableViewHeaderFooterView
        header?.textLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        header?.textLabel?.textColor = .white
        header?.contentView.backgroundColor = Theme.Colors.vaccineTitleBackgroundColor()
    }
    
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
        
        cell.lotNumberLabel.text = "Lot #\(lotNumber)"
        cell.issuerLabel.text = issuer
        cell.manufacturerLabel.text = "Couldnt get label by cvx"
        
        
        //MARK: --> For some reason vaccine value is still nil. gotta figure this out later!
        if let vaccine = DatabaseManager.shared().getVaccineByCVX(cvx: Int(vaccineCode) ?? 0) {
            cell.manufacturerLabel.text = vaccine.description
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return entries.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
}


