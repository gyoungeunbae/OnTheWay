//
//  SettingViewController.swift
//  OnTheWayMain
//
//  Created by junwoo on 2017. 5. 15..
//  Copyright © 2017년 junwoo. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var settingTableView: UITableView!
    
    // Data model: These strings will be the data for the table view cells
    var settings: [String:[String:String]] = ["profile":["username": "samchon", "profile photo":"image"], "dailyGoal":["dailyStep":"10000"], "notification":["notification":"On"]]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // This view controller itself will provide the delegate methods and row data for the table view.
        settingTableView.delegate = self
        settingTableView.dataSource = self

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return settings.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let categoryValues = Array(settings.values)[section]
        return categoryValues.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = self.settingTableView.dequeueReusableCell(withIdentifier: "MyCell") as UITableViewCell!
        
        let categoryValue = Array(settings.values)[indexPath.section]
        // set the text from the data model
        
        let title = Array(categoryValue.keys)[indexPath.row]
        
        cell.textLabel?.text = title
        
//        if let detail:String = settings[title] {
//            cell.detailTextLabel?.text = "\(detail)"
//        }
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
}
