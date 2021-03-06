//
//  ViewController.swift
//  On The Map
//
//  Created by Cihan Turkay on 29.09.17.
//  Copyright © 2017 Cihan Turkay. All rights reserved.
//

import UIKit

class ListViewController: BaseTabController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView() //remove lines for the empty cells
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func onStudentLocationsLoaded() {
        DispatchQueue.main.async {
            if(self.tableView != nil){
                self.tableView.reloadData()
            }
        }
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let student = StudentLocationsModel.sharedInstance.studentLocations[(indexPath as NSIndexPath).row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell") as UITableViewCell!
        let name = [student.firstName, student.lastName].flatMap{$0}.joined(separator: " ")
        cell?.textLabel!.text = name
        cell?.detailTextLabel?.text = student.mediaUrl
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentLocationsModel.sharedInstance.studentLocations.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = StudentLocationsModel.sharedInstance.studentLocations[(indexPath as NSIndexPath).row]
        openURL(mediaUrl: student.mediaUrl)
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
}


