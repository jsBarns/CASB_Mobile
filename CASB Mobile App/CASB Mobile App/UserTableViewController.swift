//
//  UserTableViewController.swift
//  CASB Mobile App
//
//  Created by Jack Barnett on 11/2/18.
//  Copyright © 2018 Jack Barnett. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController {
    
    struct User {
        let appName: Any
        let appInstance: Any
        let riskLevel: Any
        let riskScore: Any
        let userName: Any
        let date: Any
    }
    
    var accessToken: String = ""
    var tenantID: String = ""
    
    var usersClean:[User] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDataForUsers()
                
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return usersClean.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "UserTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? UserTableViewCell else {
            fatalError("The dequeued cell is not an instance of UserTableCell")
        }
        
        let user = usersClean[indexPath.row]
        let ratingString = (user.riskScore as! String)
        let ratingInt = (ratingString as NSString).integerValue
        
        cell.appInstanceLabel.text = "Instance: " + (user.appInstance as! String)
        cell.appNameLabel.text = "Name: " + (user.appName as! String)
        
//        cell.dateLabel.text = (user.date as! String)
        var tempStr = (user.date as! String).components(separatedBy: "T")
        cell.dateLabel.text = tempStr[0]
        
        cell.riskLevelLabel.text = "Risk Level: " + (user.riskLevel as! String)
        cell.riskScoreLabel.text = "Risk Score: " + (user.riskScore as! String)
        cell.usernameLabel.text = (user.userName as! String)
        
        if (ratingInt >= 80) {
            cell.photoImageView.image = UIImage(named: "red")
        } else if (ratingInt >= 60) {
            cell.photoImageView.image = UIImage(named: "yellow")
        } else {
            cell.photoImageView.image = UIImage(named: "green")
        }
        
        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func getDataForUsers() {
        
        let headers = [
            "Authorization": "Bearer \(self.accessToken)",
            "X-Apprity-Tenant-Id": self.tenantID,
            "Cache-Control": "no-cache",
            "Postman-Token": "70f5c3cb-f94d-46c0-8cf1-d56dd900d949"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://api-trial.palerra.net/api/v1/reports/details/userrisk/?pagesize=25")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        
        session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    
                    if let object = json as? [String: Any] {
                        
                        if let users = object["userRiskScores"] as? [Any] {
                            
                            for user in users {
                                var userCasted = user as? [String: Any]
                                
                                var tempAppName: Any = ""
                                var tempAppInstance: Any = ""
                                var tempRiskLevel: Any = ""
                                var tempRiskScore: Any = ""
                                var tempUserName: Any = ""
                                var tempDate: Any = ""
                                
                                tempAppInstance = userCasted!["appinstance"]!
                                tempAppName = userCasted!["appname"]!
                                
                                if let userDetails = userCasted!["userRiskDetails"] as? [Any] {
                                    if let riskLevelDetails = userDetails[0] as? [String: Any] {
                                        tempRiskLevel = riskLevelDetails["value"]!
                                    }
                                    
                                    if let userNameDetails = userDetails[1] as? [String: Any] {
                                        tempUserName = userNameDetails["value"]!
                                    }
                                    
                                    if let riskScoreDetails = userDetails[2] as? [String: Any] {
                                        tempRiskScore = riskScoreDetails["value"]!
                                    }
                                    
                                    if let dateDetails = userDetails[4] as? [String: Any] {
                                        tempDate = dateDetails["value"]!
                                    }
                                }
                                
                                self.usersClean.append(User(appName: tempAppName, appInstance: tempAppInstance, riskLevel: tempRiskLevel, riskScore: tempRiskScore, userName: tempUserName, date: tempDate))
                                
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                }
                                
                                
                            }
                            
                        }
                        
                    } else {
                        print("JSON is invalid.")
                    }
                    
                } catch {
                    print(error)
                }
            }
        }.resume()
    }

}
