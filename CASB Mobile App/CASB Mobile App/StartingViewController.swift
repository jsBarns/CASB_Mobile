//
//  StartingViewController.swift
//  CASB Mobile App
//
//  Created by Jack Barnett on 11/5/18.
//  Copyright © 2018 Jack Barnett. All rights reserved.
//

import UIKit

class StartingViewController: UIViewController {
    
    @IBOutlet weak var accessKey: UITextField!
    @IBOutlet weak var accessSecret: UITextField!
    @IBOutlet weak var casbImage: UIImageView!
    
    var accessToken: String = ""
    var tenantID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        casbImage.image = UIImage(named: "casb")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func authenticate(_ sender: Any) {
        
        _ = UIViewController.displaySpinner(onView: self.view)
        
        let headers = [
            "Content-Type": "application/json",
            "Cache-Control": "no-cache",
            "Postman-Token": "bd3ec440-4a19-42ba-8beb-0be9629deb9d"
        ]
        
//        let parameters = [
//            "accessKey": accessKey.text!,
//            "accessSecret": accessSecret.text!
//            ] as [String : Any]
        
        let parameters = [
            "accessKey": "/9hSD5GpgDM/ohJE4kT7rxgYxV2fgiEC0XcfegpyU2c=",
            "accessSecret": "2F3oAOIpAjwfIumDxOhs/Gjn4EFhwpN1ECR/iR7d1XU="
            ] as [String : Any]
        
        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://api-trial.palerra.net/api/v1/token")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error!)
            } else {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: String]
                    self.accessToken = json["accessToken"]!
                    self.tenantID = json["tenantId"]!
                    
                    self.performSegue(withIdentifier: "transfer", sender: self)
                    
//                    UIViewController.removeSpinner(spinner: sv)
                    
                } catch {
                    print(error)
                }
            }
        })
        
        dataTask.resume()
        
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
    
extension UIViewController {
        
        class func displaySpinner(onView : UIView) -> UIView {
            let spinnerView = UIView.init(frame: onView.bounds)
            spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
            let ai = UIActivityIndicatorView.init(style: .white)
            ai.startAnimating()
            ai.center = CGPoint(x: spinnerView.frame.size.width / 2, y: (spinnerView.frame.size.height / 2) + 150)
            
            DispatchQueue.main.async {
                spinnerView.addSubview(ai)
                onView.addSubview(spinnerView)
            }
            
            return spinnerView
        }
        
        class func removeSpinner(spinner :UIView) {
            DispatchQueue.main.async {
                spinner.removeFromSuperview()
            }
        }
}
    

