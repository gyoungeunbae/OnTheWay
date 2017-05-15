//
//  SettingViewController.swift
//  OnTheWayMain
//
//  Created by junwoo on 2017. 5. 15..
//  Copyright © 2017년 junwoo. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var serverManager = ServerManager()
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBAction func logoutButton(_ sender: Any) {
        serverManager.logout()
        let storyboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "loginVC")
        self.present(loginVC, animated: false, completion: nil)
    }
    
    @IBOutlet weak var settingTableView: UITableView!

    // Data model: These strings will be the data for the table view cells
    var settings: [String:[String:String]] = ["profile": ["username": "samchon", "image": "photo"], "dailyGoal": ["dailyStep": "10000"], "notification": ["notification": "On"]]

    override func viewDidLoad() {
        super.viewDidLoad()

        // This view controller itself will provide the delegate methods and row data for the table view.
        settingTableView.delegate = self
        settingTableView.dataSource = self
        imagePicker.delegate = self

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
        let cell: UITableViewCell = self.settingTableView.dequeueReusableCell(withIdentifier: "MyCell") as UITableViewCell!

        let categoryValue = Array(settings.values)[indexPath.section]
        // set the text from the data model

        let title = Array(categoryValue.keys)[indexPath.row]

        cell.textLabel?.text = title

        let detail = Array(categoryValue.values)[indexPath.row]
        cell.detailTextLabel?.text = "\(detail)"

        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Array(settings.keys)[section]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //First check whether the right cell is being selected.
        
        let selectedIndexPath = tableView.indexPathForSelectedRow
        var title = tableView.cellForRow(at: indexPath)?.textLabel?.text
        var detail = tableView.cellForRow(at: indexPath)?.detailTextLabel?.text
        //If the selected row is not in the first section the method returns without doing anything.
        
        if title == "notification" {
            
            //The first row is selected and here the user can change the string in an alert sheet.
            let firstRowEditAction = UIAlertController(title: "Edit Title", message: "Please edit the title", preferredStyle: .alert)
            firstRowEditAction.addTextField(configurationHandler: { (newTitle) -> Void in
                newTitle.text = detail
            })
            
            //The cancel action will do nothing.
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
                
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            })
            
            //The Okay action will change the title that is typed in.
            let okayAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in
                print(firstRowEditAction.textFields?.first?.text)
                print(detail)
                self.settings["notification"]?.updateValue((firstRowEditAction.textFields?.first?.text)!, forKey: "notification")
                //Do some other stuff that you want to do
                tableView.reloadData()
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            })
            
            firstRowEditAction.addAction(okayAction)
            firstRowEditAction.addAction(cancelAction)
            self.present(firstRowEditAction, animated: true, completion: nil)
            
        }
        
        if title == "dailyStep" {
        
            //The first row is selected and here the user can change the string in an alert sheet.
            let firstRowEditAction = UIAlertController(title: "Edit Title", message: "Please edit the title", preferredStyle: .alert)
            firstRowEditAction.addTextField(configurationHandler: { (newTitle) -> Void in
                newTitle.text = detail
            })
            
            //The cancel action will do nothing.
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
                
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            })
            
            //The Okay action will change the title that is typed in.
            let okayAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in
                print(firstRowEditAction.textFields?.first?.text)
                print(detail)
                self.settings["dailyGoal"]?.updateValue((firstRowEditAction.textFields?.first?.text)!, forKey: "dailyStep")
                //Do some other stuff that you want to do
                tableView.reloadData()
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            })
            
            firstRowEditAction.addAction(okayAction)
            firstRowEditAction.addAction(cancelAction)
            self.present(firstRowEditAction, animated: true, completion: nil)
            
        }

        
        if title == "username" {
            
            //The first row is selected and here the user can change the string in an alert sheet.
            let firstRowEditAction = UIAlertController(title: "Edit Title", message: "Please edit the title", preferredStyle: .alert)
            firstRowEditAction.addTextField(configurationHandler: { (newTitle) -> Void in
                newTitle.text = detail
            })
            
            //The cancel action will do nothing.
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
                
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            })
            
            //The Okay action will change the title that is typed in.
            let okayAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in
                print(firstRowEditAction.textFields?.first?.text)
                print(detail)
                self.settings["profile"]?.updateValue((firstRowEditAction.textFields?.first?.text)!, forKey: "username")
                //Do some other stuff that you want to do
                tableView.reloadData()
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            })
            
            firstRowEditAction.addAction(okayAction)
            firstRowEditAction.addAction(cancelAction)
            self.present(firstRowEditAction, animated: true, completion: nil)
                
        }
        
        if title == "image" {
            
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .photoLibrary
            
            present(imagePicker, animated: true, completion: nil)
        }
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImageView?.contentMode = .scaleAspectFit
            profileImageView?.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }


    
}
