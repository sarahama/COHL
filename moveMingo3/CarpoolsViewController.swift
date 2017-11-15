//
//  CarpoolsViewController.swift
//  moveMingo3
//
//  Created by Sarah MacAdam on 2/21/17.
//  Copyright © 2017 Sarah MacAdam. All rights reserved.
//

import UIKit

class CarpoolsViewController: UIViewController {
    let url_WHW = "http://www.healthyinthehills.com"
    override func viewDidLoad() {
        super.viewDidLoad()
        let requestURL = URL(string:url_WHW)
        let request = URLRequest(url: requestURL! as URL)
        webViewWHW.loadRequest(request)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var webViewWHW: UIWebView!

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
