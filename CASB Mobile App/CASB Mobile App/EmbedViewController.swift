//
//  EmbedViewController.swift
//  CASB Mobile App
//
//  Created by Jack Barnett on 11/6/18.
//  Copyright © 2018 Jack Barnett. All rights reserved.
//

import UIKit

class EmbedViewController: UIViewController {
    
    var accessToken: String = ""
    var tenantID: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.performSegue(withIdentifier: "embed", sender: self)

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc = segue.destination as! UserTableViewController
        vc.accessToken = self.accessToken
        vc.tenantID = self.tenantID
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
